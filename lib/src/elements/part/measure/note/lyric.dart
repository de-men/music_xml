import 'package:xml/xml.dart';

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
class Lyric {
  // TODO: support attributes: color, default-x, default-y, id, justify,
  //       number, placement, print-object, relative-x, relative-y, time-only
  // TODO: support children: <extend>, <laughing>, <humming>, <end-line>,
  //       <end-paragraph>, <footnote>, <level>
  final List<LyricItem> items;
  String? name;

  /// Returns the elision of the first item
  Syllabic? get syllabic => items.first.syllabic;

  /// Returns the syllabic of the first item
  String get text => items.first.text;

  /// Parse the MusicXML `<lyric>` element.
  factory Lyric.parse(XmlElement xmlLyric, MusicXMLParserState state) {
    final items = <LyricItem>[];

    Syllabic? syllabic;
    String? text;
    String? name;
    String? elision;

    for (final child in xmlLyric.childElements) {
      switch (child.name.local) {
        case 'syllabic':
          syllabic = Syllabic.values.firstWhere(
            (e) => e.toString() == 'Syllabic.' + child.innerText,
          );
          break;
        case 'text':
          text = child.innerText;
          break;
        case 'elision':
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

    name = _parseName(xmlLyric.attributes);

    return Lyric(items, name);
  }

  Lyric(this.items, this.name);

  /// Parses the name attribute
  static String? _parseName(Iterable<XmlAttribute> attributes) {
    String? result;
    for (final attribute in attributes) {
      if (attribute.name.local == 'name') {
        result = attribute.value;
        break;
      }
    }

    return result;
  }
}
