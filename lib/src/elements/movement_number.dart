import 'package:xml/xml.dart';

import '../local.dart';

class MovementNumber extends XmlElement {
  factory MovementNumber.parse(XmlElement element) {
    return MovementNumber(element.innerText);
  }

  MovementNumber(String content)
      : super.tag(Local.movementNumber, children: [XmlText(content)]);
}
