import 'package:xml/xml.dart';

import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/line/
class Line extends XmlElement {
  final int staffLinePosition;

  factory Line.parse(XmlElement element) {
    return Line(int.parse(element.innerText));
  }

  Line(this.staffLinePosition)
      : super.tag(Local.line, children: [XmlText('$staffLinePosition')]);
}
