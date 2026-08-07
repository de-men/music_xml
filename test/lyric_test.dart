import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/local.dart';
import 'package:music_xml/src/music_xml_parser_state.dart';
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
      final syllabic = LyricSyllabic.parse(element);
      expect(syllabic.content, Syllabic.begin);
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
      final elision = LyricElision.parse(element);
      expect(elision.content, '\u00a0');
      expect(elision.toXmlString(), '<elision>\u00a0</elision>');
    });
  });

  group('Lyric.parse edge cases', () {
    Lyric parse(String xml) =>
        Lyric.parse(XmlDocument.parse(xml).rootElement, MusicXMLParserState());

    test('survives a <lyric> that opens with an <elision>', () {
      final lyric = parse('<lyric><elision>-</elision><text>a</text></lyric>');
      expect(lyric.items.single.text, 'a');
      expect(lyric.items.single.elision, '-');
    });

    test('an empty <lyric> still reports one empty syllable', () {
      final lyric = parse('<lyric/>');
      expect(lyric.text, '');
      expect(lyric.syllabic, isNull);
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
      expect(children.whereType<LyricSyllabic>().length, 2);
      expect(children.whereType<LyricText>().length, 2);
      expect(children.whereType<LyricElision>().length, 1);
    });

    test('reads items straight out of the children', () {
      final lyric = Lyric([
        LyricItem.of('Ma', syllabic: Syllabic.begin),
        LyricItem.of('ry', syllabic: Syllabic.end, elision: '\u00a0'),
      ], 'verse1');

      expect(lyric.items.length, 2);
      expect(lyric.items[1].elision, '\u00a0');

      // There is only one copy of the data, so editing the children shows up
      // in the items straight away.
      lyric.children.add(LyricText('had'));
      expect(lyric.items.length, 3);
      expect(lyric.items.last.text, 'had');
      expect(lyric.toXmlString(), contains('<text>had</text>'));
    });

    test('keeps the element objects so attributes have somewhere to live', () {
      final lyric =
          document.score.parts.single.measures.first.notes[1].lyrics!.first;
      final item = lyric.items.first;
      expect(item.textElement, isA<LyricText>());
      expect(item.syllabicElement, isA<LyricSyllabic>());
      expect(item.textElement.content, item.text);
      expect(item.syllabicElement!.content, item.syllabic);
    });

    test('is itself the element the note writes out', () {
      final lyric =
          document.score.parts.single.measures.first.notes[1].lyrics!.first;
      expect(lyric, isA<XmlElement>());
      expect(lyric.name.local, Local.lyric);
      expect(lyric.lyricName, 'verse1');
      expect(lyric.syllabic, Syllabic.single);
      expect(lyric.text, '1.');
    });
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/elision-element/
  group('<elision> example', () {
    // U+203F UNDERTIE, the character the example uses to join "cro" and "a".
    const undertie = '\u203f';

    final document = MusicXmlDocument.parse(
      File('test/assets/elision-element.xml').readAsStringSync(),
    );
    final lyric =
        document.score.parts.single.measures.first.notes.single.lyrics!.single;

    test('splits the two syllables around the elision', () {
      expect(lyric.items.length, 2);

      expect(lyric.items[0].syllabic, Syllabic.end);
      expect(lyric.items[0].text, 'cro');
      expect(lyric.items[0].elision, isNull);

      expect(lyric.items[1].syllabic, Syllabic.single);
      expect(lyric.items[1].text, 'a');
      // The elision belongs to the item it is written in front of.
      expect(lyric.items[1].elision, undertie);
    });

    test('reads the number attribute', () {
      expect(lyric.number, NmToken('1'));
      expect(lyric.lyricName, isNull);
    });

    test('writes the children back in the order the example uses', () {
      final written = XmlDocument.parse(
        document.toXmlString(),
      ).findAllElements(Local.lyric).single;

      expect(written.childElements.map((e) => e.name.local), [
        'syllabic',
        'text',
        'elision',
        'syllabic',
        'text',
      ]);
      expect(written.childElements.map((e) => e.innerText), [
        'end',
        'cro',
        undertie,
        'single',
        'a',
      ]);
      expect(written.getAttribute('number'), '1');
    });

    test('still drops the unsupported default-y attribute', () {
      final written = XmlDocument.parse(
        document.toXmlString(),
      ).findAllElements(Local.lyric).single;

      // Delete this test once <lyric> keeps its position attributes.
      expect(written.getAttribute('default-y'), isNull);
    });
  });
}
