import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/data_types/step.dart' as dts;
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/grace-element-appoggiatura/
final pitchXml = File('test/assets/pitch-element.xml');
// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/alter-element-microtones/
final alterXml = File('test/assets/alter-element-microtones.xml');

void main() {
  test('<pitch>', () {
    final document = MusicXmlDocument.parse(pitchXml.readAsStringSync());

    final pitch =
        document.score.parts.single.measures.single.notes.single.pitch!;
    expect(pitch.step.step, dts.Step.G);
    expect(pitch.octave.octave, 3);
  });
  test('<alter> (Microtones)', () {
    final document = MusicXmlDocument.parse(alterXml.readAsStringSync());

    final pitch =
        document.score.parts.single.measures.single.notes.single.pitch!;
    expect(pitch.step.step, dts.Step.B);
    expect(pitch.alter!.alter, -0.5);
    expect(pitch.octave.octave, 4);
  });
}
