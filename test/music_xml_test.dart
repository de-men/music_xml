import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fraction/fraction.dart';
import 'package:music_xml/music_xml.dart';

final file = File('test/assets/musicXML.xml');

void main() {
  final document = MusicXmlDocument.parse(file.readAsStringSync());
  group('parse', () {
    test('MusicXmlDocument.parse', () {
      expect(document.scoreParts.length, 1);
      expect(document.parts.length, 1);
      expect(document.totalTimeSecs, moreOrLessEquals(49.5));
    });

    test('ScorePart.parse', () {
      final scorePart = document.scoreParts.values.single;
      expect(scorePart.id, 'P1');
      expect(scorePart.name, '');
      expect(scorePart.midiChannel, 1);
      expect(scorePart.midiProgram, 41);
    });

    test('Part.parse', () {
      final part = document.parts.single;
      expect(part.id, 'P1');
      expect(part.scorePart, document.scoreParts.values.single);
      expect(part.measures.length, 33);
    });

    test('Measure.parse', () {
      final measure = document.parts.single.measures.first;
      expect(measure.notes.length, 7);
      expect(measure.chordSymbols.length, 0);
      expect(measure.tempos.length, 0);
      expect(measure.duration, 18);
    });

    test('Note.parse', () {
      final note = document.parts.single.measures.first.notes.last;
      expect(note.midiChannel, 1);
      expect(note.midiProgram, 41);
      expect(note.velocity, 64);
      expect(note.voice, 1);
      expect(note.isRest, false);
      expect(note.isInChord, false);
      expect(note.isGraceNote, false);
      expect(note.pitch?.key, 'Bb4');
      expect(note.pitch?.value, 70);
    });

    test('Duration.parse', () {
      final duration =
          document.parts.single.measures.first.notes.last.noteDuration;
      expect(duration.duration, 2);
      expect(duration.midiTicks, moreOrLessEquals(73.33333333333333));
      expect(duration.seconds, moreOrLessEquals(0.16666666666666666));
      expect(duration.timePosition, moreOrLessEquals(1.3333333333333333));
      expect(duration.dots, 0);
      expect(duration.type, 'eighth');
      expect(duration.tupletRatio, Fraction(3, 2));
      expect(duration.isGraceNote, false);
    });

    test('ChordSymbol.parse', () {
      final chordSymbol = document.parts.single.measures[1].chordSymbols.single;
      expect(chordSymbol.timePosition, moreOrLessEquals(1.5));
      expect(chordSymbol.root, 'F');
      expect(chordSymbol.kind, '');
      expect(chordSymbol.degrees.length, 0);
      expect(chordSymbol.bass, null);
    });

    test('TimeSignature.parse', () {
      final timeSignature = document.parts.single.measures.first.timeSignature;
      assert(timeSignature != null);
      expect(timeSignature!.numerator, 3);
      expect(timeSignature.denominator, 4);
      expect(timeSignature.timePosition, 0);
    });

    test('KeySignature.parse', () {
      final keySignature = document.parts.single.measures.first.keySignature;
      assert(keySignature != null);
      expect(keySignature!.key, -1);
      expect(keySignature.mode, 'major');
      expect(keySignature.timePosition, 0);
    });
  });
}
