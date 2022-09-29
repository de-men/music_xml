import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

final file = File('test/assets/musicXML.xml');

void main() {
  group('constructor', () {
    test('ChordSymbol', () {
      expect(ChordSymbol(), isNotNull);
    });
    test('KeySignature', () {
      expect(KeySignature(), isNotNull);
    });
    test('MusicXMLParserState', () {
      expect(MusicXMLParserState(), isNotNull);
    });
    test('ScorePart', () {
      expect(ScorePart(), isNotNull);
    });
    test('Measure', () {
      expect(Measure(number: 0), isNotNull);
    });
    test('NoteDuration', () {
      expect(
          NoteDuration(
            1,
            1,
            1.0,
            0,
            0,
            '',
            0.0,
            false,
          ),
          isNotNull);
    });
    test('Note', () {
      expect(
          Note(
            0,
            0,
            0,
            0,
            false,
            false,
            false,
            NoteDuration(
              0,
              0,
              0,
              0,
              0,
              '',
              0.0,
              false,
            ),
            null,
            null,
            [],
          ),
          isNotNull);
    });
    test('Part', () {
      expect(Part('id', ScorePart(), [Measure(number: 0)]), isNotNull);
    });
    test('Tempo', () {
      expect(Tempo(0, 0), isNotNull);
    });
    test('TimeSignature', () {
      final timeSignature = TimeSignature(
        divisions: 2,
        numerator: 4,
        denominator: 8,
        timePosition: 0,
      );

      expect(timeSignature.beats, 2);
      expect(timeSignature.beatType, 4);
      expect(timeSignature.numerator, 4);
      expect(timeSignature.denominator, 8);
    });
    test('MusicXmlDocument', () {
      expect(
        MusicXmlDocument(
          XmlDocument([]),
          {'scorePart': ScorePart()},
          [
            Part('id', ScorePart(), [Measure(number: 0)]),
          ],
          0.0,
        ),
        isNotNull,
      );
      expect(
        MusicXmlDocument.fromXml(XmlDocument([])),
        isNotNull,
      );
    });
  });
  group('parse', () {
    final document = MusicXmlDocument.parse(file.readAsStringSync());
    test('MusicXmlDocument.parse', () {
      expect(document.scoreParts.length, 1);
      expect(document.parts.length, 1);
      expect(document.totalTimeSecs, closeTo(49.5, 1E-1));
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
      expect(measure.number, 1);
      expect(measure.notes.length, 7);
      expect(measure.chordSymbols.length, 0);
      expect(measure.tempos.length, 0);
      expect(measure.duration, 18);
    });

    test('Print.parse', () {
      final measures = document.parts.single.measures;
      expect(measures.first.prints.first.pageNumber, 1);
      expect(measures.first.prints.first.newSystem, false);
      expect(measures[4].prints.first.newSystem, true);
    });

    test('Barline.parse', () {
      final measures = document.parts.single.measures;
      expect(measures.last.barline?.location, RightLeftMiddle.right);
      expect(measures.last.barline?.barStyle, BarStyle.lightHeavy);
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

    group('Lyric.parse', () {
      test('with a note containing multiple lyrics', () {
        final note3 = document.parts.single.measures.first.notes[2];
        expect(note3.lyrics?.first.syllabic, Syllabic.end);
        expect(note3.lyrics?.first.text, 'ny');
        expect(note3.lyrics?.first.name, 'verse1');

        expect(note3.lyrics?.last.syllabic, Syllabic.end);
        expect(note3.lyrics?.last.text, 're ...');
        expect(note3.lyrics?.last.name, 'verse2');
      });

      test('with a note containing one lyric with multiple text items', () {
        final lyric =
            document.parts.single.measures.first.notes[1].lyrics!.first;
        expect(lyric.name, 'verse1');

        final firstTextItem = lyric.items.first;
        expect(firstTextItem.syllabic, Syllabic.single);
        expect(firstTextItem.text, '1.');

        final secondTextItem = lyric.items.last;
        expect(secondTextItem.syllabic, Syllabic.begin);
        expect(secondTextItem.text, 'Ma');
      });
    });

    test('Tie.parse', () {
      // Get two notes that are tied together
      final measures = document.parts.single.measures;
      final startNote = measures[7].notes.first;
      final stopNote = measures[8].notes.first;
      expect(startNote.ties.first.type, StartStop.start);
      expect(stopNote.ties.first.type, StartStop.stop);

      // Check isNoteOn, isNoteOff
      expect(startNote.isNoteOn, isTrue);
      expect(startNote.isNoteOff, isFalse);

      expect(stopNote.isNoteOn, isFalse);
      expect(stopNote.isNoteOff, isTrue);

      // Check continuesOtherNote and isContinuedByOtherNote
      expect(startNote.continuesOtherNote, isFalse);
      expect(startNote.isContinuedByOtherNote, isTrue);

      expect(stopNote.continuesOtherNote, isTrue);
      expect(stopNote.isContinuedByOtherNote, isFalse);

      // Tied duration should be the sum of the durations of tied notes
      expect(
        startNote.noteDurationTied.seconds,
        startNote.noteDuration.seconds + stopNote.noteDuration.seconds,
      );

      expect(
        stopNote.noteDurationTied.seconds,
        startNote.noteDuration.seconds + stopNote.noteDuration.seconds,
      );

      // Time position should be the position of the first note
      expect(
        startNote.noteDurationTied.timePosition,
        startNote.noteDuration.timePosition,
      );

      expect(
        stopNote.noteDurationTied.timePosition,
        startNote.noteDuration.timePosition,
      );
    });

    test('Duration.parse', () {
      final duration =
          document.parts.single.measures.first.notes.last.noteDuration;
      expect(duration.duration, 2);
      expect(duration.midiTicks, closeTo(73.33333333333333, 0));
      expect(duration.seconds, closeTo(0.16666666666666666, 0));
      expect(duration.timePosition, closeTo(1.3333333333333333, 0));
      expect(duration.dots, 0);
      expect(duration.type, 'eighth');
      expect(duration.tupletRatio, closeTo(1.5, 0));
      expect(duration.isGraceNote, false);
    });

    test('ChordSymbol.parse', () {
      final chordSymbol = document.parts.single.measures[1].chordSymbols.single;
      expect(chordSymbol.timePosition, closeTo(1.5, 0));
      expect(chordSymbol.root, 'F');
      expect(chordSymbol.kind, '');
      expect(chordSymbol.degrees.length, 0);
      expect(chordSymbol.bass, null);
    });

    test('Root.parse', () {
      final chordSymbol = document.parts.single.measures[2].chordSymbols.first;
      expect(chordSymbol.rootTypeSafe?.alter, -1);
      expect(chordSymbol.rootTypeSafe?.step, Step.b);
      expect(chordSymbol.kindTypeSafe, Kind.major);
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
