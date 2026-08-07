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

/// The opening item of a [Lyric]: `syllabic? text`.
///
/// It holds no elision, because the content model only allows one in front of
/// a later `<text>`.
class LyricItem {
  final LyricSyllabic? syllabicElement;
  final LyricText textElement;

  LyricItem(this.textElement, {this.syllabicElement});

  /// Builds an item from plain values instead of elements.
  factory LyricItem.of(String text, {Syllabic? syllabic}) => LyricItem(
    LyricText(text),
    syllabicElement: syllabic == null ? null : LyricSyllabic(syllabic),
  );

  Syllabic? get syllabic => syllabicElement?.content;

  String get text => textElement.content;
}

/// The `elision syllabic?` group that starts a new syllable.
///
/// The elision is required and the syllabic is optional, so a `<syllabic>`
/// with no `<elision>` in front of it cannot be built.
class SyllableStart {
  final LyricElision elisionElement;
  final LyricSyllabic? syllabicElement;

  SyllableStart(this.elisionElement, {this.syllabicElement});

  /// Builds a syllable start from plain values instead of elements.
  factory SyllableStart.of(String elision, {Syllabic? syllabic}) =>
      SyllableStart(
        LyricElision(elision),
        syllabicElement: syllabic == null ? null : LyricSyllabic(syllabic),
      );

  String get elision => elisionElement.content;

  Syllabic? get syllabic => syllabicElement?.content;
}

/// A later item of a [Lyric]: `(elision syllabic?)? text`.
class LyricNextItem {
  /// The group that starts a new syllable. Null when this `<text>` is another
  /// formatting run of the syllable in front of it.
  final SyllableStart? start;

  final LyricText textElement;

  LyricNextItem(this.textElement, {this.start});

  /// Another formatting run of the syllable in front of this one.
  factory LyricNextItem.run(String text) => LyricNextItem(LyricText(text));

  /// A new syllable, joined to the one before it by an elision.
  factory LyricNextItem.elided(
    String elision,
    String text, {
    Syllabic? syllabic,
  }) => LyricNextItem(
    LyricText(text),
    start: SyllableStart.of(elision, syllabic: syllabic),
  );

  String? get elision => start?.elision;

  Syllabic? get syllabic => start?.syllabic;

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

  /// The opening item, which never has an elision in front of it.
  LyricItem get first => _group(children).first ?? LyricItem.of('');

  /// The items after [first].
  ///
  /// Read back from [children] on every call, so the list is unmodifiable.
  /// Add or remove items by editing [children].
  List<LyricNextItem> get rest => List.unmodifiable(_group(children).rest);

  /// Returns the syllabic of the first item
  Syllabic? get syllabic => first.syllabic;

  /// Returns the text of the first item
  String get text => first.text;

  /// Groups a run of lyric children into the items of the content model.
  ///
  /// Input that the content model forbids is repaired rather than kept: an
  /// `<elision>` before the first `<text>` is dropped, and so is a
  /// `<syllabic>` that has no `<elision>` in front of it.
  static ({LyricItem? first, List<LyricNextItem> rest}) _group(
    Iterable<XmlNode> nodes,
  ) {
    LyricItem? first;
    final rest = <LyricNextItem>[];

    LyricElision? elision;
    LyricSyllabic? syllabic;

    for (final node in nodes) {
      switch (node) {
        case LyricElision():
          elision = node;
        case LyricSyllabic():
          syllabic = node;
        case LyricText():
          if (first == null) {
            first = LyricItem(node, syllabicElement: syllabic);
          } else {
            rest.add(
              LyricNextItem(
                node,
                start: elision == null
                    ? null
                    : SyllableStart(elision, syllabicElement: syllabic),
              ),
            );
          }
          elision = null;
          syllabic = null;
      }
    }

    return (first: first, rest: rest);
  }

  /// Parse the MusicXML `<lyric>` element.
  factory Lyric.parse(XmlElement xmlLyric, MusicXMLParserState state) {
    final parsed = <XmlNode>[];

    for (final child in xmlLyric.childElements) {
      switch (child.name.local) {
        case Local.syllabic:
          parsed.add(LyricSyllabic.parse(child));
          break;
        case Local.text:
          parsed.add(LyricText.parse(child));
          break;
        case Local.elision:
          parsed.add(LyricElision.parse(child));
          break;
        default:
      }
    }

    final grouped = _group(parsed);
    final number = xmlLyric.getAttribute(Local.number);

    return Lyric(
      // A `<lyric>` with no `<text>` still reports one empty item, so that
      // [text] and [syllabic] stay safe to read.
      grouped.first ?? LyricItem.of(''),
      rest: grouped.rest,
      lyricName: xmlLyric.getAttribute(Local.name),
      number: number == null ? null : NmToken(number),
    );
  }

  Lyric(
    LyricItem first, {
    List<LyricNextItem> rest = const [],
    this.lyricName,
    this.number,
  }) : super.tag(
         Local.lyric,
         attributes: [
           if (number != null) NmTokenAttr(Local.number, number),
           if (lyricName != null) TokenAttr(Local.name, lyricName),
         ],
         children: [
           if (first.syllabicElement != null) first.syllabicElement!,
           first.textElement,
           for (final item in rest) ...[
             if (item.start != null) ...[
               item.start!.elisionElement,
               if (item.start!.syllabicElement != null)
                 item.start!.syllabicElement!,
             ],
             item.textElement,
           ],
         ],
       );
}
