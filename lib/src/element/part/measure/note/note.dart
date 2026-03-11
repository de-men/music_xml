import 'package:music_xml/src/element/part/measure/note/unpitched/unpitched.dart';
import 'package:xml/xml.dart';

import 'chore.dart';
import 'grace/grace.dart';
import 'pitch/pitch.dart';
import '../../../../basic_attributes.dart';
import '../../../../local.dart';
import '../../../../lyric.dart';
import '../../../../music_xml_parser_state.dart';
import '../../../../note_duration.dart';
import '../../../../tie.dart';

/// Internal representation of a MusicXML <note> element.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/note/
class Note extends XmlElement {
  final Grace? grace;
  final Chord? chord;
  final Pitch? pitch;
  final Unpitched? unpitched;

  final int midiChannel;
  final int midiProgram;
  final int velocity;
  final int voice;
  final bool isRest;
  final NoteDuration noteDuration;

  /// Tied notes will have the same note id.
  int get noteId => _noteId;
  int _noteId = ++_noteIdCounter;
  static int _noteIdCounter = 0;

  NoteDuration? _noteDurationTied;
  MapEntry<String, int>? pitchMap;
  Iterable<Lyric>? lyrics;
  List<Tie> ties;

  bool get isGraceNote => grace != null;

  bool get isInChord => chord != null;

  /// Parse the MusicXML <note> element.
  factory Note.parse(XmlElement xmlNote, MusicXMLParserState state) {
    Grace? grace;
    Chord? chord;
    Pitch? pitch;
    Unpitched? unpitched;
    var voice = 1;
    var isRest = false;
    String? duration;
    var dots = 0;
    String? type;
    double? tupletRatio;

    final List<Lyric> lyrics = [];
    List<Tie> ties = [];

    MapEntry<String, int>? pitchMap;
    for (final child in xmlNote.childElements) {
      switch (child.name.local) {
        case Local.grace:
          grace = Grace.parse(child);
          break;
        case Local.chord:
          chord = Chord();
          break;
        case Local.pitch:
          pitchMap = _parsePitch(child, state);
          pitch = Pitch.parse(child);
          break;
        case Local.unpitched:
          unpitched = Unpitched.parse(child);
          break;
        case 'duration':
          duration = child.innerText;
          break;
        case 'rest':
          isRest = true;
          break;
        case 'voice':
          voice = int.parse(child.innerText);
          break;
        case 'dot':
          dots++;
          break;
        case 'type':
          type = child.innerText;
          break;
        case 'time-modification':
          // A time-modification element represents a tuplet_ratio
          tupletRatio = _parseTuplet(child);
          break;
        case 'lyric':
          lyrics.add(Lyric.parse(child, state));
          break;
        case 'tie':
          ties.add(Tie.parse(child, state));
          break;
        default:
        // Ignore other tag types because they are not relevant to Magenta.
      }
    }
    final noteDuration = NoteDuration.parse(
      chord != null,
      grace != null,
      duration,
      dots,
      type,
      tupletRatio,
      state,
    );

    return Note(
      grace,
      chord,
      pitch,
      unpitched,
      state.midiChannel,
      state.midiProgram,
      state.velocity,
      voice,
      isRest,
      noteDuration,
      pitchMap,
      lyrics.isNotEmpty ? lyrics : null,
      ties,
    );
  }

  Note(
    this.grace,
    this.chord,
    this.pitch,
    this.unpitched,
    this.midiChannel,
    this.midiProgram,
    this.velocity,
    this.voice,
    this.isRest,
    this.noteDuration,
    this.pitchMap,
    this.lyrics,
    this.ties,
  ) : super.tag(
          Local.note,
          children: [
            if (grace != null) grace,
            if (chord != null) chord,
            if (pitch != null) pitch,
            if (unpitched != null) unpitched,
          ],
        );

  /// Returns the combined duration of tied notes
  NoteDuration get noteDurationTied => _noteDurationTied ?? noteDuration;

  /// Update the combined duration of tied notes
  void set noteDurationTied(NoteDuration d) => _noteDurationTied = d;

  /// Initialize the id of the tied note
  void updateNoteId(int id) {
    assert(continuesOtherNote); // id can only be updated on tied notes
    _noteId = id;
  }

  /// Returns true if this note is not tied to a previous note
  bool get isNoteOn => ties.isEmpty || ties.first.type != StartStop.stop;

  /// Returns true if this note is not tied to a following note
  bool get isNoteOff => ties.isEmpty || ties.last.type != StartStop.start;

  /// Returns true if this note is tied to a previous note
  bool get continuesOtherNote => !isNoteOn;

  /// Returns true if this note is tied to a following note
  bool get isContinuedByOtherNote => !isNoteOff;

  /// Parse the MusicXML <pitch> element.
  static MapEntry<String, int> _parsePitch(
    XmlElement xmlPitch,
    MusicXMLParserState state,
  ) {
    final step = xmlPitch.getElement('step')?.innerText ?? '';
    var alterText = '';
    var alter = 0.0;
    final xmlAlter = xmlPitch.getElement('alter');
    if (xmlAlter != null) alterText = xmlAlter.innerText;

    final octave = xmlPitch.getElement('octave')?.innerText ?? '';

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
    final numerator = int.parse(
      xmlTimeModification.getElement('actual-notes')!.innerText,
    );
    final denominator = int.parse(
      xmlTimeModification.getElement('normal-notes')!.innerText,
    );
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
