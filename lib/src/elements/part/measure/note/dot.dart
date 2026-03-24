import 'package:xml/xml.dart';

import '../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/dot/
class Dot extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, font-family,
  //       font-size, font-style, font-weight, placement, relative-x,
  //       relative-y

  factory Dot.parse(XmlElement element) {
    return Dot();
  }

  Dot() : super.tag(Local.dot);
}
