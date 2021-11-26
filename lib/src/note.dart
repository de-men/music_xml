import 'package:fraction/fraction.dart';
import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';
import 'note_duration.dart';

/// Internal representation of a MusicXML <note> element.
class Note {
  late final int midiChannel;
  late final int midiProgram;
  late final int velocity;
  late final int voice;
  late final bool isRest;
  late final bool isInChord;
  late final bool isGraceNote;
  late final NoteDuration noteDuration;
  MapEntry<String, int>? pitch;

  /// Parse the MusicXML <note> element.
  Note(XmlElement xmlNote, MusicXMLParserState state) {
    var voice = 1;
    var isRest = false;
    var isInChord = false;
    var isGraceNote = false;
    noteDuration = NoteDuration(state);

    midiChannel = state.midiChannel;
    midiProgram = state.midiProgram;
    velocity = state.velocity;

    for (final child in xmlNote.childElements) {
      switch (child.name.local) {
        case 'chord':
          isInChord = true;
          break;
        case 'duration':
          noteDuration.parseDuration(isInChord, isGraceNote, child.text);
          break;
        case 'pitch':
          _parsePitch(child, state);
          break;
        case 'rest':
          isRest = true;
          break;
        case 'voice':
          voice = int.parse(child.text);
          break;
        case 'dot':
          noteDuration.dots += 1;
          break;
        case 'type':
          noteDuration.type = child.text;
          break;
        case 'time-modification':
          // A time-modification element represents a tuplet_ratio
          _parseTuplet(child);
          break;
        case 'unpitched':
          throw UnsupportedError('Unpitched notes are not supported');
        default:
        // Ignore other tag types because they are not relevant to Magenta.
      }
    }

    this.voice = voice;
    this.isRest = isRest;
    this.isInChord = isInChord;
    this.isGraceNote = isGraceNote;
  }

  /// Parse the MusicXML <pitch> element.
  void _parsePitch(XmlElement xmlPitch, MusicXMLParserState state) {
    final step = xmlPitch.getElement('step')?.text ?? '';
    var alterText = '';
    var alter = 0.0;
    final xmlAlter = xmlPitch.getElement('alter');
    if (xmlAlter != null) alterText = xmlAlter.text;

    final octave = xmlPitch.getElement('octave')?.text ?? '';

    // Parse alter string to a float (floats represent microtonal alterations)
    if (alterText.isNotEmpty) alter = double.parse(alterText);

    // Check if this is a semitone alter (i.e. an integer) or microtonal (float)
    final alterSemitones = alter.toInt(); // Number of semitones
    final isMicrotonalAlter = (alter != alterSemitones);

    // Visual pitch representation
    var alterString = '';
    if (alterSemitones == -2) {
      alterString = 'bb';
    } else if (alterSemitones == -1) {
      alterString = 'b';
    } else if (alterSemitones == 1) {
      alterString = '#';
    } else if (alterSemitones == 2) {
      alterString = 'x';
    }

    if (isMicrotonalAlter) alterString += ' (microtones) ';

    // N.B. - pitch_string does not account for transposition
    final pitchString = '$step$alterString$octave';

    // Compute MIDI pitch number (C4 = 60, C1 = 24, C0 = 12)
    var midiPitch = pitchToMidiPitch(step, alter, octave);
    // Transpose MIDI pitch
    midiPitch += state.transpose;
    pitch = MapEntry(pitchString, midiPitch);
  }

  /// Parses a tuplet ratio.
  ///
  /// Represented in MusicXML by the <time-modification> element.
  /// Args:
  ///   xmlTimeModification: An xml time-modification element.
  void _parseTuplet(XmlElement xmlTimeModification) {
    final numerator =
        int.parse(xmlTimeModification.getElement('actual-notes')!.text);
    final denominator =
        int.parse(xmlTimeModification.getElement('normal-notes')!.text);
    noteDuration.tupletRatio = Fraction(numerator, denominator);
  }
}

/// Convert MusicXML pitch representation to MIDI pitch number.
int pitchToMidiPitch(String step, double alter, String octave) {
  var pitchClass = 0;
  switch (step) {
    case 'C':
      pitchClass = 0;
      break;
    case 'D':
      pitchClass = 2;
      break;
    case 'E':
      pitchClass = 4;
      break;
    case 'F':
      pitchClass = 5;
      break;
    case 'G':
      pitchClass = 7;
      break;
    case 'A':
      pitchClass = 9;
      break;
    case 'B':
      pitchClass = 11;
      break;
    default:
      // Raise exception for unknown step (ex: 'Q')
      throw XmlParserException('Unable to parse pitch step $step');
  }

  pitchClass = (pitchClass + alter.toInt()) % 12;
  return (12 + pitchClass) + (int.parse(octave) * 12);
}
