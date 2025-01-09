import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/element/part/measure/attributes/clef/sign.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/bass-clef-down-octave/
final bassClefDownOctave = File('test/assets/bass-clef-down-octave.xml');
// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/percussion-clef/
final percussionClef = File('test/assets/percussion-clef.xml');

void main() {
  test('Bass Clef Down Octave', () {
    final document =
        MusicXmlDocument.parse(bassClefDownOctave.readAsStringSync());

    final clef = document
        .score.parts.single.measures.single.attributesList.single.clefs.single;
    expect(clef, isNotNull);
    expect(clef.sign.content, ClefSign.F);
    expect(clef.line?.staffLinePosition, 4);
    expect(clef.clefOctaveChange?.integer, -1);
  });

  test('Percussion Clef', () {
    final document = MusicXmlDocument.parse(percussionClef.readAsStringSync());

    final clef = document
        .score.parts.single.measures.single.attributesList.single.clefs.single;
    expect(clef, isNotNull);
    expect(clef.sign.content, ClefSign.percussion);
    expect(clef.line, isNull);
    expect(clef.clefOctaveChange, isNull);
  });
}
