import 'package:xml/xml.dart';

import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/fifths/
class Fifths extends XmlElement {
  final int fifths;

  factory Fifths.parse(XmlElement element) {
    return Fifths(int.parse(element.innerText));
  }

  Fifths(this.fifths) : super.tag(Local.fifths, children: [XmlText('$fifths')]);
}
