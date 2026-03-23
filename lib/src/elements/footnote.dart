import 'package:xml/xml.dart';

import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/footnote/
class Footnote extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, dir, enclosure,
  //       font-family, font-size, font-style, font-weight, halign, justify,
  //       letter-spacing, line-height, line-through, overline, relative-x,
  //       relative-y, rotation, underline, valign, xml:lang, xml:space
  final String content;

  factory Footnote.parse(XmlElement element) {
    return Footnote(element.innerText);
  }

  Footnote(this.content)
      : super.tag(Local.footnote, children: [XmlText(content)]);
}
