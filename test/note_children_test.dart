import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/data_types/accidental_value.dart';
import 'package:music_xml/src/data_types/beam_value.dart';
import 'package:music_xml/src/data_types/stem_value.dart';
import 'package:music_xml/src/elements/part/measure/note/accidental.dart';
import 'package:music_xml/src/elements/part/measure/note/beam.dart';
import 'package:music_xml/src/elements/part/measure/note/staff.dart';
import 'package:music_xml/src/elements/part/measure/note/stem.dart';
import 'package:test/test.dart';

final asset = File('test/assets/notations-element.xml');

void main() {
  late List<Note> notes;

  setUp(() {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());
    notes = document.score.parts.first.measures.first.notes;
  });

  test('<beam> parsing', () {
    expect(notes[0].beams.length, 1);
    expect(notes[0].beams.first, isA<Beam>());
    expect(notes[0].beams.first.beamValue, BeamValue.begin);
    expect(notes[0].beams.first.number?.intValue, 1);

    expect(notes[1].beams.first.beamValue, BeamValue.end);
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/beam-element/
  test('<beam> with continue, multi-level beaming', () {
    final beamAsset = File('test/assets/beam-element.xml');
    final doc = MusicXmlDocument.parse(beamAsset.readAsStringSync());
    final beamNotes = doc.score.parts.first.measures.first.notes;

    expect(beamNotes[0].beams[0].beamValue, BeamValue.begin);
    expect(beamNotes[0].beams[0].number?.intValue, 1);

    expect(beamNotes[1].beams[0].beamValue, BeamValue.continueBeam);

    expect(beamNotes[2].beams[0].beamValue, BeamValue.end);

    // 16th notes with two beam levels
    expect(beamNotes[3].beams.length, 2);
    expect(beamNotes[3].beams[0].beamValue, BeamValue.continueBeam);
    expect(beamNotes[3].beams[0].number?.intValue, 1);
    expect(beamNotes[3].beams[1].beamValue, BeamValue.begin);
    expect(beamNotes[3].beams[1].number?.intValue, 2);

    expect(beamNotes[4].beams.length, 2);
    expect(beamNotes[4].beams[0].beamValue, BeamValue.end);
    expect(beamNotes[4].beams[1].beamValue, BeamValue.end);
  });

  test('<stem> parsing', () {
    expect(notes[0].stem, isA<Stem>());
    expect(notes[0].stem!.stemValue, StemValue.up);

    expect(notes[3].stem!.stemValue, StemValue.down);
  });

  test('<staff> parsing', () {
    expect(notes[0].staff, isA<Staff>());
    expect(notes[0].staff!.staffNumber, 1);

    expect(notes[2].staff, isNull);
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/staff-element/
  test('<staff> cross-staff beaming', () {
    final staffAsset = File('test/assets/staff-element.xml');
    final doc = MusicXmlDocument.parse(staffAsset.readAsStringSync());
    final staffNotes = doc.score.parts.first.measures.first.notes;

    expect(staffNotes[0].staff!.staffNumber, 2);
    expect(staffNotes[1].staff!.staffNumber, 1);
    expect(staffNotes[2].staff!.staffNumber, 1);
    expect(staffNotes[2].isInChord, isTrue);
    expect(staffNotes[3].staff!.staffNumber, 1);
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/accidental-element/
  test('<accidental> parsing', () {
    expect(notes[0].accidental, isNull);

    expect(notes[1].accidental, isA<Accidental>());
    expect(notes[1].accidental!.accidentalValue, AccidentalValue.sharp);
  });
}
