import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/data_types/stem_value.dart';
import 'package:music_xml/src/data_types/tied_type.dart';
import 'package:music_xml/src/elements/part/measure/note/stem.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tied-element/
final asset = File('test/assets/tied-element.xml');

void main() {
  late List<Note> notes;

  setUp(() {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());
    notes = document.score.parts.first.measures.first.notes;
  });

  test('parses four notes (two pitched, two rests)', () {
    expect(notes.length, 4);
    expect(notes[0].isRest, isFalse);
    expect(notes[1].isRest, isFalse);
    expect(notes[2].isRest, isTrue);
    expect(notes[3].isRest, isTrue);
  });

  test('<tie> on first note is start', () {
    expect(notes[0].ties.length, 1);
    expect(notes[0].ties.first.type.startStop, StartStop.start);
  });

  test('<tie> on second note is stop', () {
    expect(notes[1].ties.length, 1);
    expect(notes[1].ties.first.type.startStop, StartStop.stop);
  });

  test('<tied> start in notations of first note', () {
    final notations = notes[0].notations;
    expect(notations.length, 1);
    expect(notations.first.tieds.length, 1);
    expect(notations.first.tieds.first.tiedType, TiedType.start);
  });

  test('<tied> stop and let-ring in notations of second note', () {
    final notations = notes[1].notations;
    expect(notations.length, 1);
    expect(notations.first.tieds.length, 2);
    expect(notations.first.tieds[0].tiedType, TiedType.stop);
    expect(notations.first.tieds[1].tiedType, TiedType.letRing);
  });

  test('<stem> values are parsed', () {
    expect(notes[0].stem, isA<Stem>());
    expect(notes[0].stem!.stemValue, StemValue.down);
    expect(notes[1].stem!.stemValue, StemValue.down);
  });

  test('rests have no notations or ties', () {
    expect(notes[2].notations, isEmpty);
    expect(notes[2].ties, isEmpty);
    expect(notes[3].notations, isEmpty);
    expect(notes[3].ties, isEmpty);
  });
}
