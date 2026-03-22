import 'package:xml/xml.dart';

import '../../attributes/token_attribute.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/creator/
class Creator extends XmlElement {
  final String content;
  final String? type;

  factory Creator.parse(XmlElement element) {
    return Creator(
      element.innerText,
      type: element.getAttribute(Local.type),
    );
  }

  Creator(this.content, {this.type})
      : super.tag(
          Local.creator,
          attributes: [if (type != null) TokenAttr(Local.type, type)],
          children: [XmlText(content)],
        );
}
