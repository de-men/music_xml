import 'package:xml/xml.dart';

import '../local.dart';

class MovementNumber extends XmlElement {
  final String number;

  factory MovementNumber.parse(XmlElement element) {
    return MovementNumber(element.innerText);
  }

  MovementNumber(this.number) : super.tag(Local.movementNumber);
}
