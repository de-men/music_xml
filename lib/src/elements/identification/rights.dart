import 'package:xml/xml.dart';

import '../../attributes/token_attribute.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/rights/
class Rights extends XmlElement {
  final String content;
  final String? type;

  factory Rights.parse(XmlElement element) {
    return Rights(
      element.innerText,
      type: element.getAttribute(Local.type),
    );
  }

  Rights(this.content, {this.type})
      : super.tag(
          Local.rights,
          attributes: [if (type != null) TokenAttr(Local.type, type)],
          children: [XmlText(content)],
        );
}
