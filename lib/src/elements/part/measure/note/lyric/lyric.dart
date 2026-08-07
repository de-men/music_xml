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

/// One syllable of a [Lyric].
///
/// Two `<text>` elements that are not separated by an `<elision>` are the same
/// syllable with different formatting, so [texts] can hold more than one run.
class LyricSyllable {
  final LyricSyllabic? syllabicElement;

  /// The formatting runs of this syllable. Never empty.
  final List<LyricText> texts;

  LyricSyllable(this.texts, {this.syllabicElement})
    : assert(texts.isNotEmpty, 'a syllable needs at least one <text>');

  /// Builds a syllable from plain values instead of elements.
  factory LyricSyllable.of(String text, {Syllabic? syllabic}) => LyricSyllable([
    LyricText(text),
  ], syllabicElement: syllabic == null ? null : LyricSyllabic(syllabic));

  Syllabic? get syllabic => syllabicElement?.content;

  /// The formatting runs joined together.
  String get text => texts.map((run) => run.content).join();
}

/// A [LyricSyllable] joined to the one before it by an `<elision>`.
///
/// The elision is required here because the content model only allows a later
/// `<syllabic>` when an `<elision>` comes first, so this type makes an invalid
/// lyric impossible to build.
class ElidedSyllable {
  final LyricElision elisionElement;
  final LyricSyllable syllable;

  ElidedSyllable(this.elisionElement, this.syllable);

  /// Builds an elided syllable from plain values instead of elements.
  factory ElidedSyllable.of(
    String elision,
    String text, {
    Syllabic? syllabic,
  }) => ElidedSyllable(
    LyricElision(elision),
    LyricSyllable.of(text, syllabic: syllabic),
  );

  String get elision => elisionElement.content;
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

  /// The first syllable, which never has an elision in front of it.
  LyricSyllable get first => _group(children).first ?? LyricSyllable.of('');

  /// The syllables after [first], each with the elision that joins it.
  List<ElidedSyllable> get rest => _group(children).rest;

  /// Every syllable, in order.
  List<LyricSyllable> get syllables => [
    first,
    for (final elided in rest) elided.syllable,
  ];

  /// Returns the syllabic of the first syllable
  Syllabic? get syllabic => first.syllabic;

  /// Returns the text of the first syllable
  String get text => first.text;

  /// Groups a run of lyric children into syllables, split on `<elision>`.
  ///
  /// Input that the content model forbids is repaired rather than kept: an
  /// `<elision>` before the first `<text>` is dropped, and a second
  /// `<syllabic>` inside one syllable is ignored.
  static ({LyricSyllable? first, List<ElidedSyllable> rest}) _group(
    Iterable<XmlNode> nodes,
  ) {
    LyricSyllable? first;
    final rest = <ElidedSyllable>[];

    LyricElision? openingElision;
    LyricSyllabic? syllabic;
    var texts = <LyricText>[];

    void flush() {
      if (texts.isEmpty) return;
      final syllable = LyricSyllable(texts, syllabicElement: syllabic);
      if (first == null) {
        first = syllable;
      } else {
        rest.add(ElidedSyllable(openingElision!, syllable));
      }
      texts = <LyricText>[];
      syllabic = null;
      openingElision = null;
    }

    for (final node in nodes) {
      switch (node) {
        case LyricElision():
          flush();
          // A leading elision has no syllable to join, so it is dropped.
          if (first != null) openingElision = node;
        case LyricSyllabic():
          syllabic ??= node;
        case LyricText():
          texts.add(node);
      }
    }
    flush();

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
      // A `<lyric>` with no `<text>` still reports one empty syllable, so that
      // [text] and [syllabic] stay safe to read.
      grouped.first ?? LyricSyllable.of(''),
      rest: grouped.rest,
      lyricName: xmlLyric.getAttribute(Local.name),
      number: number == null ? null : NmToken(number),
    );
  }

  Lyric(
    LyricSyllable first, {
    List<ElidedSyllable> rest = const [],
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
           ...first.texts,
           for (final elided in rest) ...[
             elided.elisionElement,
             if (elided.syllable.syllabicElement != null)
               elided.syllable.syllabicElement!,
             ...elided.syllable.texts,
           ],
         ],
       );
}
