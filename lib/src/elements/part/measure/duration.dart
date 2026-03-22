import 'package:xml/xml.dart';

import '../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/duration/
class Duration extends XmlElement {
  final int positiveDivisions;

  factory Duration.parse(XmlElement element) {
    return Duration(int.parse(element.innerText));
  }

  Duration(this.positiveDivisions)
      : super.tag(Local.duration, children: [XmlText('$positiveDivisions')]);
}
