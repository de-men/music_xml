import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/bass-clef-down-octave/
final bassClefDownOctave = File('test/assets/bass-clef-down-octave.xml');
// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/percussion-clef/
final percussionClef = File('test/assets/percussion-clef.xml');

void main() {
  test('Bass Clef Down Octave', () {
    final document =
        MusicXmlDocument.parse(bassClefDownOctave.readAsStringSync());

    final clef = document.parts.single.measures.single.clefSignature;
    expect(clef, isNotNull);
    expect(clef!.sign, 'F');
    expect(clef.line, 4);
    expect(clef.clefOctaveChange, -1);
  });

  test('Percussion Clef', () {
    final document = MusicXmlDocument.parse(percussionClef.readAsStringSync());

    final clef = document.parts.single.measures.single.clefSignature;
    expect(clef, isNotNull);
    expect(clef!.sign, 'percussion');
    expect(clef.line, isNull);
    expect(clef.clefOctaveChange, isNull);
  });
}
