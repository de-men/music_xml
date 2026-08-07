import 'package:xml/xml.dart';

import '../../../../../local.dart';

/// The character that joins two syllables sung on one note, usually an
/// elision mark or a non-breaking space.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/elision/
class Elision extends XmlElement {
  // TODO: support attributes: color, font-family, font-size, font-style,
  //       font-weight, smufl
  final String content;

  factory Elision.parse(XmlElement element) => Elision(element.innerText);

  Elision(this.content)
    : super.tag(Local.elision, children: [XmlText(content)]);
}
