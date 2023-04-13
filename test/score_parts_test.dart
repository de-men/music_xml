import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

final multipleScoreParts = File('test/assets/multipleScoreParts.xml');
final emptyScoreParts = File('test/assets/emptyScoreParts.xml');

void main() {
  test('MultipleScoreParts', () {
    expect(() => MusicXmlDocument.parse(multipleScoreParts.readAsStringSync()),
        throwsA(isA<StateError>()));
    expect(
        () => MusicXmlDocument.parse(multipleScoreParts.readAsStringSync()),
        throwsA(predicate(
            (e) => e.toString().contains('Bad state: Too many elements'))));
  });
  test('EmptyScoreParts', () {
    final document = MusicXmlDocument.parse(emptyScoreParts.readAsStringSync());
    expect(document.scoreParts.length, 0);
  });
}
