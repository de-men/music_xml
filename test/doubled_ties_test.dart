import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

final file = File('test/assets/doubledTies.xml');

void main() {
  test('DoubledTies', () {
    final document = MusicXmlDocument.parse(file.readAsStringSync());
    // Get 4 notes that are tied together
    final notes = document.parts.single.measures.single.notes;
    final startNote1 = notes.first;
    final startNote2 = notes[1];
    final stopNote1 = notes[2];
    final stopNote2 = notes.last;

    // Check isNoteOn, isNoteOff
    expect(startNote1.isNoteOn, isTrue);
    expect(startNote1.isNoteOff, isFalse);

    expect(startNote2.isNoteOn, isTrue);
    expect(startNote2.isNoteOff, isFalse);

    expect(stopNote1.isNoteOn, isFalse);
    expect(stopNote1.isNoteOff, isTrue);

    expect(stopNote2.isNoteOn, isFalse);
    expect(stopNote2.isNoteOff, isTrue);

    expect(startNote1.isContinuedByOtherNote, isTrue);
    expect(startNote2.isContinuedByOtherNote, isTrue);

    expect(stopNote1.isContinuedByOtherNote, isFalse);
    expect(stopNote2.isContinuedByOtherNote, isFalse);

    expect(startNote1.ties.length, 1);
    expect(startNote2.ties.length, 1);
    expect(stopNote1.ties.length, 1);
    expect(stopNote2.ties.length, 1);

    expect(startNote1.ties.single.type, StartStop.start);
    expect(startNote2.ties.single.type, StartStop.start);
    expect(stopNote1.ties.single.type, StartStop.stop);
    expect(stopNote2.ties.single.type, StartStop.stop);

    expect(startNote1.pitch!.value, stopNote1.pitch!.value);
    expect(startNote2.pitch!.value, stopNote2.pitch!.value);
  });
}
