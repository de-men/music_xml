import 'package:xml/xml.dart';

import '../../../../../local.dart';

/// The words of a `<lyric>`.
///
/// Named `LyricText` and not `Text` so it does not clash with the `Text`
/// widget when this package is used from Flutter.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/text/
class LyricText extends XmlElement {
  // TODO: support attributes: color, dir, font-family, font-size, font-style,
  //       font-weight, letter-spacing, rotation, underline, overline,
  //       line-through, xml:lang
  final String content;

  factory LyricText.parse(XmlElement element) => LyricText(element.innerText);

  LyricText(this.content) : super.tag(Local.text, children: [XmlText(content)]);
}
