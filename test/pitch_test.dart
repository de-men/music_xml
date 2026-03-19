import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/data_type/step.dart' as dts;
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

  test('toMidiPitch computes correct MIDI number', () {
    final document = MusicXmlDocument.parse(pitchXml.readAsStringSync());
    final pitch =
        document.score.parts.single.measures.single.notes.single.pitch!;

    // G3 = 55
    expect(pitch.toMidiPitch(), 55);
  });

  test('toMidiPitch with flat alter', () {
    final document = MusicXmlDocument.parse(
      File('test/assets/musicXML.xml').readAsStringSync(),
    );
    final note = document.score.parts.single.measures.first.notes.last;

    // Bb4 = 70
    expect(note.pitch!.toMidiPitch(), 70);
    expect(note.pitchMap?.value, 70);
  });

  test('toPitchString produces human-readable string', () {
    final document = MusicXmlDocument.parse(
      File('test/assets/musicXML.xml').readAsStringSync(),
    );
    final note = document.score.parts.single.measures.first.notes.last;

    expect(note.pitch!.toPitchString(), 'Bb4');
    expect(note.pitchMap?.key, note.pitch!.toPitchString());
  });

  test('pitchMap is derived from Pitch object', () {
    final document = MusicXmlDocument.parse(pitchXml.readAsStringSync());
    final note = document.score.parts.single.measures.single.notes.single;

    expect(note.pitchMap, isNotNull);
    expect(note.pitchMap!.key, note.pitch!.toPitchString());
    expect(note.pitchMap!.value, note.pitch!.toMidiPitch());
  });
}
