import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

// https://github.com/de-men/music_xml/issues/53
// <type> must survive parse -> toXmlString() -> parse.
const _wholeNote = '''
<score-partwise version="4.0">
  <part-list>
    <score-part id="P1">
      <part-name>Music</part-name>
    </score-part>
  </part-list>
  <part id="P1">
    <measure number="1">
      <attributes>
        <divisions>1</divisions>
      </attributes>
      <note>
        <pitch>
          <step>C</step>
          <octave>4</octave>
        </pitch>
        <duration>4</duration>
        <type>whole</type>
      </note>
    </measure>
  </part>
</score-partwise>''';

const _restNoType = '''
<score-partwise version="4.0">
  <part-list>
    <score-part id="P1">
      <part-name>Music</part-name>
    </score-part>
  </part-list>
  <part id="P1">
    <measure number="1">
      <attributes>
        <divisions>1</divisions>
      </attributes>
      <note>
        <rest/>
        <duration>4</duration>
      </note>
    </measure>
  </part>
</score-partwise>''';

void main() {
  test('<type> is kept after toXmlString()', () {
    final doc = MusicXmlDocument.parse(_wholeNote);
    final note = doc.score.parts.first.measures.first.notes.first;
    expect(note.noteDuration.type, 'whole');
    expect(note.type?.noteTypeValue, NoteTypeValue.whole);

    final xml = doc.toXmlString();
    expect(xml, contains('<type>whole</type>'));

    final reparsed = MusicXmlDocument.parse(xml);
    final reparsedNote = reparsed.score.parts.first.measures.first.notes.first;
    expect(reparsedNote.noteDuration.type, 'whole');
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/accent-element/
  test('official <accent> example keeps <type>half</type> on round-trip', () {
    final accentAsset = File('test/assets/accent-element.xml');
    final doc = MusicXmlDocument.parse(accentAsset.readAsStringSync());
    final note = doc.score.parts.first.measures.first.notes.first;
    expect(note.type?.noteTypeValue, NoteTypeValue.half);
    expect(note.noteDuration.type, 'half');

    final xml = doc.toXmlString();
    expect(xml, contains('<type>half</type>'));

    final reparsed = MusicXmlDocument.parse(xml);
    final reparsedNote = reparsed.score.parts.first.measures.first.notes.first;
    expect(reparsedNote.type?.noteTypeValue, NoteTypeValue.half);
    expect(reparsedNote.noteDuration.type, 'half');
  });

  test('a note without <type> stays without <type>', () {
    final doc = MusicXmlDocument.parse(_restNoType);
    final note = doc.score.parts.first.measures.first.notes.first;
    expect(note.type, isNull);
    // default stays 'quarter' in NoteDuration, but no tag is written.
    expect(note.noteDuration.type, 'quarter');

    final xml = doc.toXmlString();
    expect(xml.contains('<type>'), isFalse);
  });

  test('digit-prefixed values map both ways', () {
    expect(parseNoteTypeValue('16th'), NoteTypeValue.n16th);
    expect(parseNoteTypeValue('1024th'), NoteTypeValue.n1024th);
    expect(noteTypeValueToString[NoteTypeValue.n16th], '16th');
    expect(NoteType.of(NoteTypeValue.n16th).toXmlString(), '<type>16th</type>');
  });

  test('non-standard <type> value round-trips and gives null enum', () {
    final noteType = NoteType('dotted-half');
    expect(noteType.noteTypeValue, isNull);
    expect(noteType.toXmlString(), '<type>dotted-half</type>');
    expect(parseNoteTypeValue('dotted-half'), isNull);
  });

  test('size attribute is parsed and serialized', () {
    final parsed = NoteType.parse(
      XmlDocument.parse('<type size="cue">half</type>').rootElement,
    );
    expect(parsed.noteTypeValue, NoteTypeValue.half);
    expect(parsed.size, SymbolSize.cue);
    expect(parsed.toXmlString(), '<type size="cue">half</type>');

    expect(
      NoteType.of(NoteTypeValue.eighth, size: SymbolSize.large).toXmlString(),
      '<type size="large">eighth</type>',
    );
  });

  test('grace-cue size maps both ways', () {
    expect(parseSymbolSize('grace-cue'), SymbolSize.graceCue);
    expect(symbolSizeToString[SymbolSize.graceCue], 'grace-cue');
  });
}
