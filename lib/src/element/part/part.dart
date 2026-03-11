import 'package:xml/xml.dart';

import '../../../music_xml.dart';
import '../../local.dart';
import '../id.dart';

/// Internal represention of a MusicXML <part> element.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/part-partwise/
class Part extends XmlElement {
  final Id id;

  // One or more times
  final List<Measure> measures;

  /// Parse the <part> element.
  factory Part.parse(
    MusicXMLParserState state,
    XmlElement element,
    Map<String, ScorePart> scoreParts,
  ) {
    final idAttribute = element.getAttribute(Local.id)!;
    final scorePart = scoreParts[idAttribute]!;

    // Reset the time position when parsing each part
    state.timePosition = 0;
    state.midiChannel = scorePart.midiChannel;
    state.midiProgram = scorePart.midiProgram;
    state.transpose = 0;

    final xmlMeasures = element.findElements(Local.measure);
    if (xmlMeasures.isEmpty) {
      throw StateError('Part must contain at least one measure');
    }
    final measures = xmlMeasures.map((measure) {
      // Issue #674: Repair measures that do not contain notes
      // by inserting a whole measure rest
      _repairEmptyMeasure(measure);
      return Measure.parse(state, measure);
    }).toList();

    // Update durations of tied notes
    _updateDurationsOfTiedNotes(measures);

    return Part(Id(idAttribute), measures);
  }

  static void _updateDurationsOfTiedNotes(List<Measure> measures) {
    // Collect all tied notes
    final tiedNotes = Map<int, Map<int, List<Note>>>();

    for (final measure in measures) {
      final notes = measure.notes;
      for (final currentNote in notes) {
        // Skip untied notes
        if (currentNote.ties.isEmpty) {
          continue;
        }

        // If note is note on, create a new entry in tiedNotes
        if (currentNote.isNoteOn) {
          tiedNotes.putIfAbsent(currentNote.voice, () => {});
          tiedNotes[currentNote.voice]!.putIfAbsent(
            currentNote.pitchMap!.value,
            () => [currentNote],
          );
        }
        // If note is a continuing note, add the note to tiedNotes
        else if (currentNote.continuesOtherNote) {
          final notes =
              tiedNotes[currentNote.voice]?[currentNote.pitchMap!.value];
          assert(notes != null);
          final startNote = notes!.first;
          currentNote.updateNoteId(startNote.noteId);
          notes.add(currentNote);
        }

        // If note ends, calculate tied duration
        if (currentNote.isNoteOff) {
          final notesForVoice = tiedNotes[currentNote.voice]!;
          final pitch = currentNote.pitchMap!.value;
          final notes = notesForVoice[pitch]!;
          notesForVoice.remove(pitch);
          final first = notes.first.noteDuration;
          final tiedDuration = NoteDuration(
            0,
            0,
            0,
            first.timePosition,
            first.dots,
            first.type,
            first.tupletRatio,
            first.isGraceNote,
          );

          for (final tiedNote in notes) {
            tiedDuration.duration += tiedNote.noteDuration.duration;
            tiedDuration.midiTicks += tiedNote.noteDuration.midiTicks;
            tiedDuration.seconds += tiedNote.noteDuration.seconds;
            tiedNote.noteDurationTied = tiedDuration;
          }
        }
      }
    }
  }

  Part(this.id, this.measures)
      : super(XmlName(Local.part), [id], [...measures]);

  /// Repair a measure if it is empty by inserting a whole measure rest.
  ///
  /// If a <measure> only consists of a <forward> element that advances
  /// the time cursor, remove the <forward> element and replace
  /// with a whole measure rest of the same duration.
  static void _repairEmptyMeasure(XmlElement measure) {
    final xmlForwards = measure.findElements('forward').toList();
    final noteCount = measure.findElements('note').length;
    if (noteCount == 0 && xmlForwards.length == 1) {
      final xmlForward = xmlForwards.single;
      final forwardDuration =
          xmlForward.getElement('duration')?.innerText ?? '0';

      xmlForward.parent!.children.remove(xmlForward);

      final restNote = XmlDocument.parse(
        '<note>'
        '<rest/>'
        '<duration>$forwardDuration</duration>'
        '<voice>1</voice>'
        '<type>whole</type>'
        '<staff>1</staff>'
        '</note>',
      ).rootElement.copy();
      measure.children.add(restNote);
    }
  }
}
