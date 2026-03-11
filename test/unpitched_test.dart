import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/data_types/step.dart' as dts;
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/unpitched-element/
final asset = File('test/assets/unpitched-element.xml');

void main() {
  test('<unpitched>', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    final notes = document.score.parts.single.measures.single.notes;
    expect(notes.length, 4);

    final unpitched0 = notes[0].unpitched!;
    expect(unpitched0.displayStep.step, dts.Step.F);
    expect(unpitched0.displayOctave.octave, 4);

    final unpitched1 = notes[1].unpitched!;
    expect(unpitched1.displayStep.step, dts.Step.A);
    expect(unpitched1.displayOctave.octave, 4);

    final unpitched2 = notes[2].unpitched!;
    expect(unpitched2.displayStep.step, dts.Step.D);
    expect(unpitched2.displayOctave.octave, 5);

    final unpitched3 = notes[3].unpitched!;
    expect(unpitched3.displayStep.step, dts.Step.E);
    expect(unpitched3.displayOctave.octave, 5);
  });
}
