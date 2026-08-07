import 'package:xml/xml.dart';

import '../../../../../attributes/nmtoken_attribute.dart';
import '../../../../../attributes/token_attribute.dart';
import '../../../../../data_types/nmtoken.dart';
import '../../../../../data_types/syllabic.dart';
import '../../../../../local.dart';
import '../../../../../music_xml_parser_state.dart';
import 'elision.dart';
import 'syllabic.dart';
import 'text.dart';

class LyricItem {
  Syllabic? syllabic;
  String text;
  String? elision;

  LyricItem(this.syllabic, this.text, this.elision);
}

/// Internal representation of a MusicXML `<lyric>` element.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/lyric/
class Lyric {
  // TODO: support attributes: color, default-x, default-y, id, justify,
  //       placement, print-object, relative-x, relative-y, time-only
  // TODO: support children: <extend>, <laughing>, <humming>, <end-line>,
  //       <end-paragraph>, <footnote>, <level>
  final List<LyricItem> items;

  /// The `name` attribute, e.g. `verse1`.
  String? name;

  /// Distinguishes the verses when a note carries more than one `<lyric>`.
  NmToken? number;

  /// Returns the syllabic of the first item
  Syllabic? get syllabic => items.first.syllabic;

  /// Returns the text of the first item
  String get text => items.first.text;

  /// Parse the MusicXML `<lyric>` element.
  factory Lyric.parse(XmlElement xmlLyric, MusicXMLParserState state) {
    final items = <LyricItem>[];

    Syllabic? syllabic;
    String? text;
    String? elision;

    for (final child in xmlLyric.childElements) {
      switch (child.name.local) {
        case Local.syllabic:
          syllabic = LyricSyllabic.parse(child).content;
          break;
        case Local.text:
          text = LyricText.parse(child).content;
          break;
        case Local.elision:
          items.add(LyricItem(syllabic, text!, elision));
          elision = LyricElision.parse(child).content;
          syllabic = null;
          text = null;
          break;
        default:
      }
    }

    if (text == null) {
      text = '';
    }
    items.add(LyricItem(syllabic, text, elision));

    final number = xmlLyric.getAttribute(Local.number);

    return Lyric(
      items,
      xmlLyric.getAttribute(Local.name),
      number: number == null ? null : NmToken(number),
    );
  }

  Lyric(this.items, this.name, {this.number});

  /// Builds the `<lyric>` element that [Note] writes into its children.
  ///
  /// Content model: `syllabic? text (elision? syllabic? text)*`, so the
  /// elision of an item is written before that item's own text.
  XmlElement toXmlElement() => XmlElement.tag(
    Local.lyric,
    attributes: [
      if (number != null) NmTokenAttr(Local.number, number!),
      if (name != null) TokenAttr(Local.name, name!),
    ],
    children: [
      for (final item in items) ...[
        if (item.elision != null) LyricElision(item.elision!),
        if (item.syllabic != null) LyricSyllabic(item.syllabic!),
        LyricText(item.text),
      ],
    ],
  );
}
