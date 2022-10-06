// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/kind-value/
import 'package:music_xml/src/camel_case.dart';

enum SimpleKind {
  major,
  minor,
  augmented,
  diminished,
  sus,
  other,
}

enum Kind {
  undefined,
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

extension SimpleKindExtension on Kind {
  SimpleKind get simple => this == Kind.major ||
          this == Kind.major ||
          this == Kind.major11th ||
          this == Kind.major13th ||
          this == Kind.majorMinor ||
          this == Kind.majorNinth ||
          this == Kind.majorSeventh ||
          this == Kind.majorSixth ||
          this == Kind.dominant ||
          this == Kind.dominant11th ||
          this == Kind.dominant13th ||
          this == Kind.dominantNinth ||
          this == Kind.neapolitan
      ? SimpleKind.major
      : this == Kind.minor ||
              this == Kind.minor11th ||
              this == Kind.minor13th ||
              this == Kind.minorNinth ||
              this == Kind.minorSeventh ||
              this == Kind.minorSixth
          ? SimpleKind.minor
          : this == Kind.suspendedFourth || this == Kind.suspendedSecond
              ? SimpleKind.sus
              : this == Kind.diminished ||
                      this == Kind.diminishedSeventh ||
                      this == Kind.halfDiminished
                  ? SimpleKind.diminished
                  : this == Kind.augmented || this == Kind.augmentedSeventh
                      ? SimpleKind.augmented
                      : SimpleKind.other;
}

Kind parseKind(String str) => Kind.values
    .firstWhere((e) => e.toString() == 'Kind.' + lowerCamelCase(str));
