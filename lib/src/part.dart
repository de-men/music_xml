import 'package:music_xml/src/note.dart';
import 'package:music_xml/src/note_duration.dart';
import 'package:xml/xml.dart';

import 'measure.dart';
import 'music_xml_parser_state.dart';
import 'score_part.dart';

/// Internal represention of a MusicXML <part> element.
class Part {
  final String id;
  final ScorePart scorePart;
  final List<Measure> measures;

  /// Parse the <part> element.
  factory Part.parse(
    XmlElement xmlPart,
    Map<String, ScorePart> scoreParts,
    MusicXMLParserState state,
  ) {
    final id = xmlPart.getAttribute('id') ?? '';
    final scorePart = scoreParts[id] ?? ScorePart();

    // Reset the time position when parsing each part
    state.timePosition = 0;
    state.midiChannel = scorePart.midiChannel;
    state.midiProgram = scorePart.midiProgram;
    state.transpose = 0;

    final xmlMeasures = xmlPart.findAllElements('measure');
    final measures = xmlMeasures.map((measure) {
      // Issue #674: Repair measures that do not contain notes
      // by inserting a whole measure rest
      _repairEmptyMeasure(measure);
      return Measure.parse(measure, state);
    }).toList();

    // Update durations of tied notes
    _updateDurationsOfTiedNotes(measures);

    return Part(id, scorePart, measures);
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
          tiedNotes[currentNote.voice] = {
            currentNote.pitch!.value: [currentNote],
          };
        }

        // If note is a continuing note, add the note to tiedNotes
        else if (currentNote.continuesOtherNote) {
          final notes = tiedNotes[currentNote.voice]?[currentNote.pitch!.value];
          assert(notes != null);
          final startNote = notes!.first;
          currentNote.updateNoteId(startNote.noteId);
          notes.add(currentNote);
        }

        // If note ends, calculate tied duration
        if (currentNote.isNoteOff) {
          final notesForVoice = tiedNotes[currentNote.voice]!;
          final pitch = currentNote.pitch!.value;
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

  Part(this.id, this.scorePart, this.measures);

  /// Repair a measure if it is empty by inserting a whole measure rest.
  /// If a <measure> only consists of a <forward> element that advances
  /// the time cursor, remove the <forward> element and replace
  /// with a whole measure rest of the same duration.
  static void _repairEmptyMeasure(XmlElement measure) {
    final xmlForwards = measure.findAllElements('forward');
    final forwardCount = xmlForwards.length;
    final noteCount = measure.findAllElements('note').length;
    if (noteCount == 0 && forwardCount == 1) {
      // Get the duration of the <forward> element
      // TODO final xmlForward = xmlForwards.single;
      // final xmlDuration = xmlForward.getElement('duration');
      // final forwardDuration = int.tryParse(xmlDuration?.text ?? '') ?? 0;

      // # Delete the <forward> element
      // measure.remove(xml_forward)
      //
      // # Insert the new note
      // new_note = '<note>'
      // new_note += '<rest /><duration>' + str(forward_duration) + '</duration>'
      // new_note += '<voice>1</voice><type>whole</type><staff>1</staff>'
      // new_note += '</note>'
      // new_note_xml = ET.fromstring(new_note)
      // measure.append(new_note_xml)
    }
  }
}
