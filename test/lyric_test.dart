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

    // A file is data, not a mistake in code. Both lyrics below break the
    // content model, and both are read and written back the way their author
    // wrote them instead of being repaired or refused.
    test('keeps an <elision> written before the first <text>', () {
      const xml = '<lyric><elision>-</elision><text>a</text></lyric>';
      final lyric = parse(xml);

      expect(lyric.items.single.text, 'a');
      expect(lyric.items.single.elision, '-');
      expect(lyric.toXmlString(), xml);
    });

    test('keeps a second <syllabic> with no <elision> in front of it', () {
      const xml =
          '<lyric><syllabic>begin</syllabic><text>Ma</text>'
          '<syllabic>end</syllabic><text>ry</text></lyric>';
      final lyric = parse(xml);

      expect(lyric.items.first.syllabic, Syllabic.begin);
      expect(lyric.items.first.text, 'Ma');
      expect(lyric.items.last.syllabic, Syllabic.end);
      expect(lyric.items.last.text, 'ry');
      expect(lyric.toXmlString(), xml);
    });

    test('an empty <lyric> has no items and is written back empty', () {
      final lyric = parse('<lyric/>');
      expect(lyric.items, isEmpty);
      expect(lyric.toXmlString(), '<lyric/>');
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

    test('holds the same elements in its items and its children', () {
      final lyric = Lyric([
        LyricItem(
          LyricText('Ma'),
          syllabicElement: LyricSyllabic(Syllabic.begin),
        ),
        LyricItem(
          LyricText('ry'),
          elisionElement: LyricElision('\u00a0'),
          syllabicElement: LyricSyllabic(Syllabic.end),
        ),
      ], lyricName: 'verse1');

      expect(lyric.items.length, 2);
      expect(lyric.items.last.elision, '\u00a0');

      // The items and the children hold the same objects, so what is read back
      // and what is written out cannot say different things.
      for (final item in lyric.items) {
        expect(lyric.children, contains(same(item.textElement)));
        if (item.elisionElement != null) {
          expect(lyric.children, contains(same(item.elisionElement)));
        }
        if (item.syllabicElement != null) {
          expect(lyric.children, contains(same(item.syllabicElement)));
        }
      }
    });

    test('items do not follow a child added by hand', () {
      final lyric = Lyric([LyricItem(LyricText('Ma'))]);

      // items is grouped once, at build time. This is the price of not
      // grouping it again on every read: <text> lands in the output, but the
      // item list stays as it was.
      lyric.children.add(LyricText('ry'));

      expect(lyric.toXmlString(), contains('<text>ry</text>'));
      expect(lyric.items.single.text, 'Ma');
    });

    test('keeps the element objects so attributes have somewhere to live', () {
      final lyric =
          document.score.parts.single.measures.first.notes[1].lyrics!.first;
      final first = lyric.items.first;
      expect(first.textElement, isA<LyricText>());
      expect(first.syllabicElement, isA<LyricSyllabic>());
      expect(first.textElement.content, first.text);
      expect(first.syllabicElement!.content, first.syllabic);
      expect(first.elisionElement, isNull);

      final second = lyric.items.last;
      expect(second.elisionElement, isA<LyricElision>());
      expect(second.syllabicElement, isA<LyricSyllabic>());
    });

    test('refuses writes through the items read back', () {
      final lyric = Lyric([LyricItem(LyricText('Ma'))]);

      // items is rebuilt from the children on each read, so a write through it
      // would quietly do nothing. It throws instead.
      expect(
        () => lyric.items.add(LyricItem(LyricText('ry'))),
        throwsUnsupportedError,
      );

      expect(lyric.toXmlString(), '<lyric><text>Ma</text></lyric>');
    });

    test('a later item can be a bare <text> with no elision', () {
      // The (elision syllabic?) group is optional, so a plain run is valid.
      final lyric = Lyric([
        LyricItem(LyricText('Ma')),
        LyricItem(LyricText('ry')),
      ]);

      expect(lyric.items.last.elision, isNull);
      expect(lyric.items.last.syllabic, isNull);
      expect(
        lyric.toXmlString(),
        '<lyric><text>Ma</text><text>ry</text></lyric>',
      );
    });

    test('refuses a later <syllabic> that has no elision to sit behind', () {
      expect(
        () => Lyric([
          LyricItem(
            LyricText('Ma'),
            syllabicElement: LyricSyllabic(Syllabic.begin),
          ),
          LyricItem(
            LyricText('ry'),
            syllabicElement: LyricSyllabic(Syllabic.end),
          ),
        ]),
        throwsA(isA<AssertionError>()),
      );
    });

    test('refuses an elision handed to the first item', () {
      expect(
        () => Lyric([
          LyricItem(LyricText('Ma'), elisionElement: LyricElision('-')),
        ]),
        throwsA(isA<AssertionError>()),
      );
    });

    test('a later <syllabic> goes out behind its elision', () {
      final lyric = Lyric([
        LyricItem(
          LyricText('Ma'),
          syllabicElement: LyricSyllabic(Syllabic.begin),
        ),
        LyricItem(
          LyricText('ry'),
          elisionElement: LyricElision('-'),
          syllabicElement: LyricSyllabic(Syllabic.end),
        ),
      ]);

      expect(lyric.childElements.map((e) => e.name.local), [
        'syllabic',
        'text',
        'elision',
        'syllabic',
        'text',
      ]);
    });

    test('is itself the element the note writes out', () {
      final lyric =
          document.score.parts.single.measures.first.notes[1].lyrics!.first;
      expect(lyric, isA<XmlElement>());
      expect(lyric.name.local, Local.lyric);
      expect(lyric.lyricName, 'verse1');
      expect(lyric.items.first.syllabic, Syllabic.single);
      expect(lyric.items.first.text, '1.');
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

      expect(lyric.items.first.syllabic, Syllabic.end);
      expect(lyric.items.first.text, 'cro');
      expect(lyric.items.first.elision, isNull);

      final second = lyric.items.last;
      expect(second.elision, undertie);
      expect(second.syllabic, Syllabic.single);
      expect(second.text, 'a');
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
