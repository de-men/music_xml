import 'package:xml/xml.dart';

import '../../../../attributes/token_attribute.dart';
import '../../../../local.dart';
import '../../../../music_xml_parser_state.dart';

/// The value of the `<syllabic>` child element.
enum Syllabic { single, begin, end, middle }

class LyricItem {
  Syllabic? syllabic;
  String text;
  String? elision;

  LyricItem(this.syllabic, this.text, this.elision);
}

/// Internal representation of a MusicXML `<lyric>` element.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/lyric/
class Lyric extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, id, justify,
  //       placement, print-object, relative-x, relative-y, time-only
  // TODO: support children: <extend>, <laughing>, <humming>, <end-line>,
  //       <end-paragraph>, <footnote>, <level>
  final List<LyricItem> items;

  /// The `name` attribute, e.g. `verse1`. Named `lyricName` because
  /// [XmlElement] already uses `name` for the tag name.
  String? lyricName;

  /// Distinguishes the verses when a note carries more than one `<lyric>`.
  String? number;

  /// Returns the elision of the first item
  Syllabic? get syllabic => items.first.syllabic;

  /// Returns the syllabic of the first item
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
          syllabic = Syllabic.values.firstWhere(
            (e) => e.toString() == 'Syllabic.' + child.innerText,
          );
          break;
        case Local.text:
          text = child.innerText;
          break;
        case Local.elision:
          items.add(LyricItem(syllabic, text!, elision));
          elision = child.innerText;
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

    return Lyric(
      items,
      xmlLyric.getAttribute(Local.name),
      number: xmlLyric.getAttribute(Local.number),
    );
  }

  Lyric(this.items, this.lyricName, {this.number})
    : super.tag(
        Local.lyric,
        attributes: [
          if (number != null) TokenAttr(Local.number, number),
          if (lyricName != null) TokenAttr(Local.name, lyricName),
        ],
        // Content model: syllabic? text (elision? syllabic? text)*, so the
        // elision of an item is written before that item's own text.
        children: [
          for (final item in items) ...[
            if (item.elision != null)
              XmlElement.tag(Local.elision, children: [XmlText(item.elision!)]),
            if (item.syllabic != null)
              XmlElement.tag(
                Local.syllabic,
                children: [XmlText(item.syllabic!.name)],
              ),
            XmlElement.tag(Local.text, children: [XmlText(item.text)]),
          ],
        ],
      );
}
