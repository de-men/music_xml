import 'package:music_xml/src/lyric.dart';
import 'package:music_xml/src/tie.dart';
import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';
import 'note_duration.dart';

/// Internal representation of a MusicXML <note> element.
class Note {
  final int midiChannel;
  final int midiProgram;
  final int velocity;
  final int voice;
  final bool isRest;
  final bool isInChord;
  final bool isGraceNote;
  final NoteDuration noteDuration;
  MapEntry<String, int>? pitch;
  Iterable<Lyric>? lyrics;
  Tie? tie;

  /// Parse the MusicXML <note> element.
  factory Note.parse(XmlElement xmlNote, MusicXMLParserState state) {
    var voice = 1;
    var isRest = false;
    var isInChord = false;
    var isGraceNote = false;
    String? duration;
    var dots = 0;
    String? type;
    double? tupletRatio;

    final List<Lyric> lyrics = [];
    Tie? tie;

    MapEntry<String, int>? pitch;
    for (final child in xmlNote.childElements) {
      switch (child.name.local) {
        case 'chord':
          isInChord = true;
          break;
        case 'duration':
          duration = child.text;
          break;
        case 'pitch':
          pitch = _parsePitch(child, state);
          break;
        case 'rest':
          isRest = true;
          break;
        case 'voice':
          voice = int.parse(child.text);
          break;
        case 'dot':
          dots++;
          break;
        case 'type':
          type = child.text;
          break;
        case 'time-modification':
          // A time-modification element represents a tuplet_ratio
          tupletRatio = _parseTuplet(child);
          break;
        case 'lyric':
          lyrics.add(Lyric.parse(child, state));
          break;
        case 'tie':
          tie = Tie.parse(child, state);
          break;
        case 'unpitched':
          throw UnsupportedError('Unpitched notes are not supported');
        default:
        // Ignore other tag types because they are not relevant to Magenta.
      }
    }
    final noteDuration = NoteDuration.parse(
      isInChord,
      isGraceNote,
      duration,
      dots,
      type,
      tupletRatio,
      state,
    );

    return Note(
      state.midiChannel,
      state.midiProgram,
      state.velocity,
      voice,
      isRest,
      isInChord,
      isGraceNote,
      noteDuration,
      pitch,
      lyrics.isNotEmpty ? lyrics : null,
      tie,
    );
  }

  Note(
    this.midiChannel,
    this.midiProgram,
    this.velocity,
    this.voice,
    this.isRest,
    this.isInChord,
    this.isGraceNote,
    this.noteDuration,
    this.pitch,
    this.lyrics,
    this.tie,
  );

  /// Parse the MusicXML <pitch> element.
  static MapEntry<String, int> _parsePitch(
    XmlElement xmlPitch,
    MusicXMLParserState state,
  ) {
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
    return MapEntry(pitchString, midiPitch);
  }

  /// Parses a tuplet ratio.
  ///
  /// Represented in MusicXML by the <time-modification> element.
  /// Args:
  ///   xmlTimeModification: An xml time-modification element.
  static double _parseTuplet(XmlElement xmlTimeModification) {
    final numerator =
        int.parse(xmlTimeModification.getElement('actual-notes')!.text);
    final denominator =
        int.parse(xmlTimeModification.getElement('normal-notes')!.text);
    return numerator / denominator;
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
