import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

final asset = File('test/assets/tempo-element.xml');

void main() {
  test('Tempo.qpm returns double', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());
    final measures = document.score.parts.single.measures;

    final tempo1 = measures[0].tempos.first;
    expect(tempo1.qpm, isA<double>());
    expect(tempo1.qpm, 120.0);

    final tempo2 = measures[1].tempos.first;
    expect(tempo2.qpm, isA<double>());
    expect(tempo2.qpm, 80.0);
  });

  test('Tempo defaults to 120 when value is 0', () {
    final tempo = Tempo(0);
    expect(tempo.qpm, 120.0);
  });

  test('Tempo.parse defaults to 120 for invalid input', () {
    final tempo = Tempo.parse('not-a-number');
    expect(tempo.qpm, 120.0);
  });
}
