import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/chord-element/
final asset = File('test/assets/chord-element.xml');

void main() {
  test('<chord>', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    final notes = document.score.parts.single.measures.single.notes;
    expect(notes.length, 3);
    expect(notes.first.chord, isNull);
    expect(notes[1].chord, isNotNull);
    expect(notes.last.chord, isNotNull);
  });
}
