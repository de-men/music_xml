import 'package:xml/xml.dart';

import '../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/part-name/
class PartName extends XmlElement {
  final String content;

  factory PartName.parse(XmlElement element) {
    return PartName(element.innerText);
  }

  PartName(this.content) : super.tag(Local.partName);
}
