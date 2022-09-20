// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/kind-value/
import 'package:music_xml/src/camel_case.dart';

enum Kind {
  augmented,
  augmentedSeventh,
  diminished,
  diminishedSeventh,
  dominant,
  dominant11th,
  dominant13th,
  dominantNinth,
  trench,
  german,
  halfDiminished,
  italian,
  major,
  major11th,
  major13th,
  majorMinor,
  majorNinth,
  majorSeventh,
  majorSixth,
  minor,
  minor11th,
  minor13th,
  minorNinth,
  minorSeventh,
  minorSixth,
  neapolitan,
  none,
  other,
  pedal,
  power,
  suspendedFourth,
  suspendedSecond,
  tristan,
}

Kind parseKind(String str) => Kind.values
    .firstWhere((e) => e.toString() == 'Kind.' + lowerCamelCase(str));
