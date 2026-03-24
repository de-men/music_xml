import 'package:xml/xml.dart';

import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/ornaments/
class Ornaments extends XmlElement {
  // TODO: support attributes: id
  final List<XmlElement> contents;

  factory Ornaments.parse(XmlElement element) {
    return Ornaments(
      contents: element.childElements.map((e) => e.copy()).toList(),
    );
  }

  Ornaments({this.contents = const []})
      : super.tag(Local.ornaments, children: [...contents]);
}
