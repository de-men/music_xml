import 'package:xml/xml.dart';

import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/technical/
class Technical extends XmlElement {
  // TODO: support attributes: id
  final List<XmlElement> contents;

  factory Technical.parse(XmlElement element) {
    return Technical(
      contents: element.childElements.map((e) => e.copy()).toList(),
    );
  }

  Technical({this.contents = const []})
      : super.tag(Local.technical, children: [...contents]);
}
