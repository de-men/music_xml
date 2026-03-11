import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

final asset = File('test/assets/attributes-time-signature.xml');

void main() {
  test('time signature is accessible from Attributes', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    final measures = document.score.parts.single.measures;
    final attrs1 = measures[0].attributesList.first;
    final attrs2 = measures[1].attributesList.first;

    expect(attrs1.times.length, 1);
    expect(attrs1.times.first.numerator, 4);
    expect(attrs1.times.first.denominator, 4);

    expect(attrs2.times.length, 1);
    expect(attrs2.times.first.numerator, 3);
    expect(attrs2.times.first.denominator, 4);
  });

  test('time signature change between measures is parsed correctly', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    final measures = document.score.parts.single.measures;

    final time1 = measures[0].attributesList.first.times.first;
    final time2 = measures[1].attributesList.first.times.first;

    expect(time1.numerator, isNot(time2.numerator),
        reason: 'Time signature should change between measures');
    expect(time1.numerator, 4);
    expect(time2.numerator, 3);
    expect(time1.denominator, time2.denominator);
  });
}
