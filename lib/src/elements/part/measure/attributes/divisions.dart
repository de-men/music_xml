import 'package:xml/xml.dart';

import '../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/divisions/
class Divisions extends XmlElement {
  final int content;

  factory Divisions.parse(XmlElement element) {
    return Divisions(int.parse(element.innerText));
  }

  Divisions(this.content)
      : super.tag(Local.divisions, children: [XmlText('$content')]);
}
