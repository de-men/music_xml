import 'package:music_xml/src/elements/part/measure/note/unpitched/unpitched.dart';
import 'package:xml/xml.dart';

import 'accidental.dart';
import 'beam.dart';
import 'chord.dart';
import 'dot.dart';
import 'grace.dart';
import 'notations/notations.dart';
import 'pitch/pitch.dart';
import '../duration.dart' as music_xml;
import 'rest.dart';
import 'staff.dart';
import 'stem.dart';
import '../../../voice.dart';
import '../../../../basic_attributes.dart';
import '../../../../local.dart';
import 'lyric.dart';
import '../../../../music_xml_parser_state.dart';
import '../../../../note_duration.dart';
import 'tie.dart';

/// Internal representation of a MusicXML `<note>` element.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/note/
class Note extends XmlElement {
  // TODO: support attributes: attack, color, default-x, default-y, dynamics,
  //       end-dynamics, font-family, font-size, font-style, font-weight, id,
  //       pizzicato, print-dot, print-leger, print-lyric, print-object,
  //       print-spacing, relative-x, relative-y, release, time-only
  // TODO: support children: <cue>, <instrument>, <footnote>, <level>,
  //       <notehead>, <notehead-text>, <play>, <listen>
  final Grace? grace;
  final Chord? chord;
  final Pitch? pitch;
  final Unpitched? unpitched;
  final Rest? rest;
  final music_xml.Duration? duration;
  final Voice? voice;
  final List<Dot> dots;
  final List<Beam> beams;
  final Stem? stem;
  final Staff? staff;
  final Accidental? accidental;
  final List<Notations> notations;

  final int midiChannel;
  final int midiProgram;
  final int velocity;
  final NoteDuration noteDuration;

  bool get isRest => rest != null;

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

  /// Parse the MusicXML `<note>` element.
  factory Note.parse(XmlElement xmlNote, MusicXMLParserState state) {
    Grace? grace;
    Chord? chord;
    Pitch? pitch;
    Unpitched? unpitched;
    Voice? voice;
    Rest? rest;
    music_xml.Duration? duration;
    final dots = <Dot>[];
    String? type;
    double? tupletRatio;

    final List<Beam> beams = [];
    Stem? stem;
    Staff? staff;
    Accidental? accidental;
    final List<Notations> notationsList = [];
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
        case Local.duration:
          duration = music_xml.Duration.parse(child);
          break;
        case Local.rest:
          rest = Rest.parse(child);
          break;
        case Local.voice:
          voice = Voice.parse(child);
          break;
        case Local.dot:
          dots.add(Dot.parse(child));
          break;
        case Local.type:
          type = child.innerText;
          break;
        case Local.timeModification:
          tupletRatio = _parseTuplet(child);
          break;
        case Local.beam:
          beams.add(Beam.parse(child));
          break;
        case Local.stem:
          stem = Stem.parse(child);
          break;
        case Local.staff:
          staff = Staff.parse(child);
          break;
        case Local.accidental:
          accidental = Accidental.parse(child);
          break;
        case Local.notations:
          notationsList.add(Notations.parse(child));
          break;
        case Local.lyric:
          lyrics.add(Lyric.parse(child, state));
          break;
        case Local.tie:
          ties.add(Tie.parse(child));
          break;
      }
    }
    final noteDuration = NoteDuration.parse(
      chord != null,
      grace != null,
      duration?.positiveDivisions,
      dots.length,
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
      rest,
      duration,
      dots,
      beams,
      stem,
      staff,
      accidental,
      notationsList,
      state.midiChannel,
      state.midiProgram,
      state.velocity,
      voice,
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
    this.rest,
    this.duration,
    this.dots,
    this.beams,
    this.stem,
    this.staff,
    this.accidental,
    this.notations,
    this.midiChannel,
    this.midiProgram,
    this.velocity,
    this.voice,
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
            if (rest != null) rest,
            if (duration != null) duration,
            if (voice != null) voice,
            ...dots,
            ...beams,
            if (stem != null) stem,
            if (staff != null) staff,
            if (accidental != null) accidental,
            ...notations,
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
  bool get isNoteOn =>
      ties.isEmpty || ties.first.type.startStop != StartStop.stop;

  /// Returns true if this note is not tied to a following note
  bool get isNoteOff =>
      ties.isEmpty || ties.last.type.startStop != StartStop.start;

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
