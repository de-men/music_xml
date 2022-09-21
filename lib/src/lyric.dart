import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

/// The value of the <syllabic> child element.
enum Syllabic {
  single,
  begin,
  end,
  middle,
}

class LyricItem {
  Syllabic? syllabic;
  String text;
  String? elision;

  LyricItem(this.syllabic, this.text, this.elision);
}

/// Internal representation of a MusicXML <lyric> element.
class Lyric {
  final List<LyricItem> items;
  String? name;

  /// Returns the elision of the first item
  Syllabic? get syllabic => items.first.syllabic;

  /// Returns the syllabic of the first item
  String get text => items.first.text;

  /// Parse the MusicXML <lyric> element.
  factory Lyric.parse(XmlElement xmlLyric, MusicXMLParserState state) {
    final items = <LyricItem>[];

    Syllabic? syllabic;
    String? text;
    String? name;
    String? elision;

    for (final child in xmlLyric.childElements) {
      switch (child.name.local) {
        case 'syllabic':
          syllabic = Syllabic.values
              .firstWhere((e) => e.toString() == 'Syllabic.' + child.text);
          break;
        case 'text':
          text = child.text;
          break;
        case 'elision':
          items.add(LyricItem(syllabic, text!, elision));
          elision = child.text;
          syllabic = null;
          text = null;
          break;
        default:
        // Ignore other tag types because they are not relevant to Magenta.
      }
    }

    if (text == null) {
      throw XmlParserException('Missing child: text');
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
