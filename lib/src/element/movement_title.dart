import 'package:xml/xml.dart';

import '../local.dart';

class MovementTitle extends XmlElement {
  final String title;

  factory MovementTitle.fromXml(XmlElement element) {
    return MovementTitle(element.innerText);
  }

  MovementTitle(this.title) : super.tag(Local.movementTitle);
}
