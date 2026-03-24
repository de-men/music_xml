import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

final asset = File('test/assets/empty-measure-forward.xml');

void main() {
  test('empty measure with only <forward> is repaired to a rest', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    final measure = document.score.parts.single.measures.single;
    expect(measure.notes.length, 1);
    expect(measure.notes.single.isRest, isTrue);
    expect(measure.notes.single.noteDuration.duration, 4);
    expect(measure.notes.single.voice?.content, '1');
  });
}
