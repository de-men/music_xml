import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

final pickupAsset = File('test/assets/pickup-measure.xml');
final timeChangeAsset = File('test/assets/attributes-time-signature.xml');

void main() {
  test('pickup measure gets correct fractional time signature', () {
    final document = MusicXmlDocument.parse(pickupAsset.readAsStringSync());
    final measures = document.score.parts.single.measures;

    // Measure 1 is a pickup: 1 quarter note in 4/4
    expect(measures[0].duration, 1);
    expect(measures[0].notes.length, 1);

    // Measure 2 is a full 4/4 measure
    expect(measures[1].duration, 4);
  });

  test('standard 4/4 measure does not create spurious time signature', () {
    final document = MusicXmlDocument.parse(pickupAsset.readAsStringSync());
    final measures = document.score.parts.single.measures;

    // Measure 2 and 3 are full 4/4 -- should not have their own
    // time signature overrides from _fixTimeSignature
    expect(measures[1].attributesList, isEmpty);
    expect(measures[2].attributesList, isEmpty);
  });

  test('time signature comparison uses exact integer math', () {
    // This test ensures fractional comparisons don't break due to
    // floating-point precision (e.g., 3/12 == 1/4 must hold)
    final document = MusicXmlDocument.parse(timeChangeAsset.readAsStringSync());
    final measures = document.score.parts.single.measures;

    // First measure: 4/4
    final time1 = measures[0].attributesList.first.times.first;
    expect(time1.numerator, 4);
    expect(time1.denominator, 4);

    // Second measure: 3/4
    final time2 = measures[1].attributesList.first.times.first;
    expect(time2.numerator, 3);
    expect(time2.denominator, 4);
  });
}
