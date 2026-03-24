import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/data_types/accidental_value.dart';
import 'package:music_xml/src/data_types/fermata_shape.dart';
import 'package:music_xml/src/data_types/start_stop_continue.dart';
import 'package:music_xml/src/data_types/tied_type.dart';
import 'package:music_xml/src/data_types/upright_inverted.dart';
import 'package:test/test.dart';

final asset = File('test/assets/notations-element.xml');

void main() {
  late List<Note> notes;

  setUp(() {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());
    notes = document.score.parts.first.measures.first.notes;
  });

  test('<notations> with <slur>', () {
    expect(notes[0].notations.length, 1);
    final notations = notes[0].notations.first;
    expect(notations.slurs.length, 1);
    expect(notations.slurs.first.slurType, StartStopContinue.start);
    expect(notations.slurs.first.number?.value, '1');

    final stopSlur = notes[1].notations.first;
    expect(stopSlur.slurs.first.slurType, StartStopContinue.stop);
  });

  test('<notations> with <tied>', () {
    final startNotations = notes[2].notations.first;
    expect(startNotations.tieds.length, 1);
    expect(startNotations.tieds.first.tiedType, TiedType.start);

    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tied-element/
    final stopNotations = notes[3].notations.first;
    expect(stopNotations.tieds.length, 2);
    expect(stopNotations.tieds[0].tiedType, TiedType.stop);
    expect(stopNotations.tieds[1].tiedType, TiedType.letRing);
  });

  test('<notations> with <fermata>', () {
    final notations = notes[2].notations.first;
    expect(notations.fermatas.length, 1);
    expect(notations.fermatas.first.fermataShape, FermataShape.normal);
    expect(notations.fermatas.first.fermataType, UprightInverted.upright);
  });

  test('<notations> with <articulations>', () {
    final notations = notes[0].notations.first;
    expect(notations.articulations.length, 1);
    expect(notations.articulations.first.contents.length, 1);
    expect(notations.articulations.first.contents.first.name.local, 'accent');
  });

  test('<notations> with <dynamics> and <ornaments>', () {
    final notations = notes[3].notations.first;
    expect(notations.dynamics.length, 1);
    expect(notations.dynamics.first.contents.first.name.local, 'ff');

    expect(notations.ornaments.length, 1);
    expect(notations.ornaments.first.contents.first.name.local, 'trill-mark');
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/accidental-mark-element-notation/
  test('<notations> with <accidental-mark>', () {
    final notations = notes[4].notations.first;
    expect(notations.accidentalMarks.length, 1);
    expect(
        notations.accidentalMarks.first.accidentalValue, AccidentalValue.sharp);
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/fingering-element-notation/
  test('<notations> with <technical> containing <fingering>', () {
    final notations = notes[5].notations.first;
    expect(notations.technicals.length, 1);
    final technical = notations.technicals.first;
    expect(technical.contents.length, 1);
    expect(technical.contents.first.name.local, 'fingering');
    expect(technical.contents.first.getAttribute('placement'), 'above');
  });

  test('<notations> with <tuplet>', () {
    final beamAsset = File('test/assets/beam-element.xml');
    final doc = MusicXmlDocument.parse(beamAsset.readAsStringSync());
    final beamNotes = doc.score.parts.first.measures.first.notes;

    expect(beamNotes[0].notations.first.tuplets.length, 1);
    expect(
        beamNotes[0].notations.first.tuplets.first.tupletType, StartStop.start);
    expect(
        beamNotes[2].notations.first.tuplets.first.tupletType, StartStop.stop);
  });

  test('existing musicXML.xml parses with notations', () {
    final mainAsset = File('test/assets/musicXML.xml');
    expect(
      () => MusicXmlDocument.parse(mainAsset.readAsStringSync()),
      returnsNormally,
    );
  });
}
