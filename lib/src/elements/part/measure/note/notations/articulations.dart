import 'package:xml/xml.dart';

import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/articulations/
class Articulations extends XmlElement {
  // TODO: support attributes: id
  final List<XmlElement> contents;

  factory Articulations.parse(XmlElement element) {
    return Articulations(
      contents: element.childElements.map((e) => e.copy()).toList(),
    );
  }

  Articulations({this.contents = const []})
      : super.tag(Local.articulations, children: [...contents]);
}
