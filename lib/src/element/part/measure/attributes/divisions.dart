import 'package:xml/xml.dart';

import '../../../../local.dart';

class Divisions extends XmlElement {
  final int content;

  factory Divisions.parse(XmlElement element) {
    return Divisions(int.parse(element.innerText));
  }

  Divisions(this.content) : super(XmlName(Local.divisions));
}