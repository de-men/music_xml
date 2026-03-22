import 'package:xml/xml.dart';

import '../local.dart';

class MovementTitle extends XmlElement {
  factory MovementTitle.parse(XmlElement element) {
    return MovementTitle(element.innerText);
  }

  MovementTitle(String content)
      : super.tag(Local.movementTitle, children: [XmlText(content)]);
}
