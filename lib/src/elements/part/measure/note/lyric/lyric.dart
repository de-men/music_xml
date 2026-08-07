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

/// One syllable of a [Lyric]: a `<text>` with the optional `<syllabic>` and
/// `<elision>` that belong to it.
class LyricItem {
  final LyricSyllabic? syllabicElement;
  final LyricText textElement;

  /// The elision written *before* [textElement], joining this syllable to the
  /// one in front of it. Null on the first item.
  final LyricElision? elisionElement;

  LyricItem({
    this.syllabicElement,
    required this.textElement,
    this.elisionElement,
  });

  /// Builds an item from plain values instead of elements.
  factory LyricItem.of(String text, {Syllabic? syllabic, String? elision}) =>
      LyricItem(
        syllabicElement: syllabic == null ? null : LyricSyllabic(syllabic),
        textElement: LyricText(text),
        elisionElement: elision == null ? null : LyricElision(elision),
      );

  Syllabic? get syllabic => syllabicElement?.content;

  String get text => textElement.content;

  String? get elision => elisionElement?.content;
}

/// Internal representation of a MusicXML `<lyric>` element.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/lyric/
class Lyric extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, id, justify,
  //       placement, print-object, relative-x, relative-y, time-only
  // TODO: support children: <extend>, <laughing>, <humming>, <end-line>,
  //       <end-paragraph>, <footnote>, <level>

  /// The `name` attribute, e.g. `verse1`. Called `lyricName` because
  /// [XmlElement] already uses `name` for the tag name, the same way as
  /// `LyricFont.lyricName`.
  String? lyricName;

  /// Distinguishes the verses when a note carries more than one `<lyric>`.
  NmToken? number;

  /// The syllables, grouped from [children] so that the elements written out
  /// and the items read back can never disagree.
  List<LyricItem> get items {
    final items = <LyricItem>[];
    LyricSyllabic? syllabic;
    LyricElision? elision;

    for (final child in children) {
      switch (child) {
        case LyricElision():
          elision = child;
        case LyricSyllabic():
          syllabic = child;
        case LyricText():
          items.add(
            LyricItem(
              syllabicElement: syllabic,
              textElement: child,
              elisionElement: elision,
            ),
          );
          syllabic = null;
          elision = null;
      }
    }

    return items;
  }

  /// Returns the syllabic of the first item
  Syllabic? get syllabic => items.first.syllabic;

  /// Returns the text of the first item
  String get text => items.first.text;

  /// Parse the MusicXML `<lyric>` element.
  factory Lyric.parse(XmlElement xmlLyric, MusicXMLParserState state) {
    final items = <LyricItem>[];
    LyricSyllabic? syllabic;
    LyricElision? elision;

    for (final child in xmlLyric.childElements) {
      switch (child.name.local) {
        case Local.syllabic:
          syllabic = LyricSyllabic.parse(child);
          break;
        case Local.text:
          items.add(
            LyricItem(
              syllabicElement: syllabic,
              textElement: LyricText.parse(child),
              elisionElement: elision,
            ),
          );
          syllabic = null;
          elision = null;
          break;
        case Local.elision:
          elision = LyricElision.parse(child);
          break;
        default:
      }
    }

    // A `<lyric>` without any `<text>` still reports one empty syllable, so
    // that `text` and `syllabic` stay safe to read.
    if (items.isEmpty) items.add(LyricItem.of(''));

    final number = xmlLyric.getAttribute(Local.number);

    return Lyric(
      items,
      xmlLyric.getAttribute(Local.name),
      number: number == null ? null : NmToken(number),
    );
  }

  Lyric(List<LyricItem> items, this.lyricName, {this.number})
    : super.tag(
        Local.lyric,
        attributes: [
          if (number != null) NmTokenAttr(Local.number, number),
          if (lyricName != null) TokenAttr(Local.name, lyricName),
        ],
        // Content model: syllabic? text (elision? syllabic? text)*, so the
        // elision of an item is written before that item's own text.
        children: [
          for (final item in items) ...[
            if (item.elisionElement != null) item.elisionElement!,
            if (item.syllabicElement != null) item.syllabicElement!,
            item.textElement,
          ],
        ],
      );
}
