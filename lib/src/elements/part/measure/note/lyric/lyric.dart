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

/// One item of a [Lyric]: `(elision syllabic?)? text`.
///
/// The elision sits in front of the text and joins this syllable to the one
/// before it, so only an item after the first can carry one. Which item this is
/// decides what it may hold, and an item on its own does not know that, so
/// [Lyric] is what keeps the order legal.
class LyricItem {
  final LyricElision? elisionElement;
  final LyricSyllabic? syllabicElement;
  final LyricText textElement;

  LyricItem(this.textElement, {this.elisionElement, this.syllabicElement});

  String? get elision => elisionElement?.content;

  Syllabic? get syllabic => syllabicElement?.content;

  String get text => textElement.content;
}

/// Internal representation of a MusicXML `<lyric>` element.
///
/// Content model: `syllabic? text ((elision syllabic?)? text)*`
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/lyric/
class Lyric extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, id, justify,
  //       placement, print-object, relative-x, relative-y, time-only
  // TODO: support the <extend>, <laughing> and <humming> alternatives, and
  //       the <end-line>, <end-paragraph>, <footnote> and <level> children

  /// The `name` attribute, e.g. `verse1`. Called `lyricName` because
  /// [XmlElement] already uses `name` for the tag name, the same way as
  /// `LyricFont.lyricName`.
  String? lyricName;

  /// Distinguishes the verses when a note carries more than one `<lyric>`.
  NmToken? number;

  /// The items, one per `<text>`.
  ///
  /// Grouped once, when the lyric is built, and unmodifiable from then on.
  /// [children] holds the same element objects, so build a new [Lyric] to
  /// change one. Editing [children] by hand does not update this list.
  final List<LyricItem> items;

  /// Parse the MusicXML `<lyric>` element.
  factory Lyric.parse(XmlElement xmlLyric, MusicXMLParserState state) {
    final items = <LyricItem>[];

    LyricElision? elision;
    LyricSyllabic? syllabic;

    for (final child in xmlLyric.childElements) {
      switch (child.name.local) {
        case Local.elision:
          elision = LyricElision.parse(child);
          break;
        case Local.syllabic:
          syllabic = LyricSyllabic.parse(child);
          break;
        case Local.text:
          // The `<text>` closes the item, so whatever came in front of it
          // belongs to it. Both are then cleared, or the next `<text>` with
          // nothing of its own would take them a second time.
          items.add(
            LyricItem(
              LyricText.parse(child),
              elisionElement: elision,
              syllabicElement: syllabic,
            ),
          );
          syllabic = null;
          elision = null;
          break;
        default:
      }
    }

    String? lyricName;
    NmToken? number;

    for (final attribute in xmlLyric.attributes) {
      switch (attribute.name.local) {
        case Local.name:
          lyricName = attribute.value;
          break;
        case Local.number:
          number = NmToken(attribute.value);
          break;
        default:
      }
    }

    // Skips the asserts: a file is data, not a mistake in code, so a lyric that
    // breaks the content model is written back the way its author wrote it.
    return Lyric._(items, lyricName: lyricName, number: number);
  }

  /// The items are written out as they are, so they have to be in the order the
  /// content model asks for.
  factory Lyric(List<LyricItem> items, {String? lyricName, NmToken? number}) {
    assert(
      items.isEmpty || items.first.elisionElement == null,
      'no <elision> may sit in front of the first <text>',
    );
    assert(
      items
          .skip(1)
          .every(
            (item) =>
                item.elisionElement != null || item.syllabicElement == null,
          ),
      'a later <syllabic> needs an <elision> in front of it',
    );

    return Lyric._(items, lyricName: lyricName, number: number);
  }

  Lyric._(List<LyricItem> items, {this.lyricName, this.number})
    : items = List.unmodifiable(items),
      super.tag(
        Local.lyric,
        attributes: [
          if (number != null) NmTokenAttr(Local.number, number),
          if (lyricName != null) TokenAttr(Local.name, lyricName),
        ],
        children: [
          for (final item in items) ...[
            if (item.elisionElement != null) item.elisionElement!,
            if (item.syllabicElement != null) item.syllabicElement!,
            item.textElement,
          ],
        ],
      );
}
