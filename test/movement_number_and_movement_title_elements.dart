import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/movement-number-and-movement-title-elements/
final file = File(
  'test/assets/movement-number-and-movement-title-elements.xml',
);

void main() {
  test('movement-number-and-movement-title-elements', () {
    final document = MusicXmlDocument.parse(file.readAsStringSync());

    expect(document.score.movementNumber!.innerText, '22');
    expect(document.score.movementTitle!.innerText, 'Mut');
  });
}
