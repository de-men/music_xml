import 'package:xml/xml.dart';

import '../../attributes/type_attr.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/creator/
class Creator extends XmlElement {
  String? get type => getAttribute('type');

  factory Creator.parse(XmlElement element) {
    return Creator(
      type: element.getAttribute('type'),
      content: element.innerText,
    );
  }

  Creator({String? type, required String content})
      : super.tag(
          Local.creator,
          attributes: [if (type != null) TypeAttr(type)],
          children: [XmlText(content)],
        );
}
