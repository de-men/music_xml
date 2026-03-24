import 'package:xml/xml.dart';

import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/dynamics/
class Dynamics extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, enclosure,
  //       font-family, font-size, font-style, font-weight, halign, id,
  //       line-through, overline, placement, relative-x, relative-y,
  //       underline, valign
  final List<XmlElement> contents;

  factory Dynamics.parse(XmlElement element) {
    return Dynamics(
      contents: element.childElements.map((e) => e.copy()).toList(),
    );
  }

  Dynamics({this.contents = const []})
      : super.tag(Local.dynamics, children: [...contents]);
}
