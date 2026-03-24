import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/data_types/beam_value.dart';
import 'package:music_xml/src/data_types/start_stop_continue.dart';
import 'package:music_xml/src/data_types/stem_value.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/voice-element/
final asset = File('test/assets/voice-element.xml');

void main() {
  late List<Note> notes;

  setUp(() {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());
    notes = document.score.parts.first.measures.first.notes;
  });

  test('parses notes across two voices', () {
    expect(notes.length, 8);
  });

  test('voice 1 notes', () {
    expect(notes[0].voice?.content, '1');
    expect(notes[1].voice?.content, '1');
    expect(notes[2].voice?.content, '1');
    expect(notes[3].voice?.content, '1');
  });

  test('voice 2 notes after backup', () {
    expect(notes[4].voice?.content, '2');
    expect(notes[5].voice?.content, '2');
    expect(notes[6].voice?.content, '2');
    expect(notes[7].voice?.content, '2');
  });

  test('voice 1 beams and stems', () {
    expect(notes[0].beams.first.beamValue, BeamValue.begin);
    expect(notes[0].stem!.stemValue, StemValue.up);

    expect(notes[1].beams.first.beamValue, BeamValue.continueBeam);

    expect(notes[2].beams.first.beamValue, BeamValue.end);

    expect(notes[3].beams, isEmpty);
  });

  test('voice 2 beams and stems', () {
    expect(notes[4].beams, isEmpty);
    expect(notes[4].stem!.stemValue, StemValue.down);

    expect(notes[5].beams.first.beamValue, BeamValue.begin);
    expect(notes[6].beams.first.beamValue, BeamValue.continueBeam);
    expect(notes[7].beams.first.beamValue, BeamValue.end);
  });

  test('slur start and stop in voice 1', () {
    final startSlur = notes[0].notations.first.slurs.first;
    expect(startSlur.slurType, StartStopContinue.start);
    expect(startSlur.number?.value, '1');

    final stopSlur = notes[3].notations.first.slurs.first;
    expect(stopSlur.slurType, StartStopContinue.stop);
  });

  test('tuplet start and stop in voice 1', () {
    expect(notes[0].notations.first.tuplets.first.tupletType, StartStop.start);
    expect(notes[2].notations.first.tuplets.first.tupletType, StartStop.stop);
  });
}
