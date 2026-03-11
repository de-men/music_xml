import 'package:music_xml/src/element/part/measure/note/unpitched/unpitched.dart';
import 'package:xml/xml.dart';

import 'chord.dart';
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

    for (final child in xmlNote.childElements) {
      switch (child.name.local) {
        case Local.grace:
          grace = Grace.parse(child);
          break;
        case Local.chord:
          chord = Chord();
          break;
        case Local.pitch:
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
        // TODO: support remaining <note> child elements
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

    final pitchMap = pitch != null
        ? MapEntry(pitch.toPitchString(),
            pitch.toMidiPitch(transpose: state.transpose))
        : null;

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
