import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

final file = File('test/assets/musicXML.xml');

void main() {
  group('NmToken', () {
    test('accepts values that a token may not start with', () {
      expect(NmToken('verse1').value, 'verse1');
      expect(NmToken('1').value, '1');
      expect(NmToken('-a.b:c_d').value, '-a.b:c_d');
    });

    test('rejects whitespace and empty values', () {
      expect(NmToken.isValid(''), isFalse);
      expect(NmToken.isValid('two words'), isFalse);
      expect(NmToken.isValid('trailing '), isFalse);
    });

    test('compares by value', () {
      expect(NmToken('1'), NmToken('1'));
      expect(NmToken('1'), isNot(NmToken('2')));
    });
  });

  group('lyric children', () {
    test('<syllabic> round trips through its value', () {
      final element = XmlDocument.parse(
        '<syllabic>begin</syllabic>',
      ).rootElement;
      final syllabic = Syllabic.parse(element);
      expect(syllabic.content, SyllabicValue.begin);
      expect(syllabic.toXmlString(), '<syllabic>begin</syllabic>');
    });

    test('<text> round trips through its content', () {
      final element = XmlDocument.parse('<text>Ma</text>').rootElement;
      final text = LyricText.parse(element);
      expect(text.content, 'Ma');
      expect(text.toXmlString(), '<text>Ma</text>');
    });

    test('<elision> round trips through its content', () {
      final element = XmlDocument.parse(
        '<elision>\u00a0</elision>',
      ).rootElement;
      final elision = Elision.parse(element);
      expect(elision.content, '\u00a0');
      expect(elision.toXmlString(), '<elision>\u00a0</elision>');
    });
  });

  group('Lyric', () {
    final document = MusicXmlDocument.parse(file.readAsStringSync());

    test('keeps the number attribute as an NmToken', () {
      final lyrics =
          document.score.parts.single.measures.first.notes[2].lyrics!;
      expect(lyrics.first.number, NmToken('1'));
      expect(lyrics.last.number, NmToken('2'));
    });

    test('builds its children from the element classes', () {
      final lyric =
          document.score.parts.single.measures.first.notes[1].lyrics!.first;
      final children = lyric.childElements.toList();
      expect(children.whereType<Syllabic>().length, 2);
      expect(children.whereType<LyricText>().length, 2);
      expect(children.whereType<Elision>().length, 1);
    });
  });
}
