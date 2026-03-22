import 'package:xml/xml.dart';

import '../../attributes/token_attribute.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/relation/
class Relation extends XmlElement {
  final String content;
  final String? type;

  factory Relation.parse(XmlElement element) {
    return Relation(
      element.innerText,
      type: element.getAttribute(Local.type),
    );
  }

  Relation(this.content, {this.type}) : super.tag(Local.relation, attributes: [if (type != null) TokenAttr(Local.type, type)], children: [XmlText(content)]);
}
