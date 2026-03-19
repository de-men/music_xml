import 'package:xml/xml.dart';

import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/relation/
class Relation extends XmlElement {
  final String? type;
  final String value;

  factory Relation.parse(XmlElement element) {
    return Relation(
      type: element.getAttribute('type'),
      value: element.innerText,
    );
  }

  Relation({this.type, required this.value}) : super.tag(Local.relation);
}
