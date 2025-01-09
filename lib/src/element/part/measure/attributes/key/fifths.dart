import 'package:xml/xml.dart';

import '../../../../../local.dart';

class Fifths extends XmlElement {
  final int fifths;

  factory Fifths.parse(XmlElement element) {
    return Fifths(int.parse(element.innerText));
  }

  Fifths(this.fifths) : super(XmlName(Local.fifths));
}