import 'package:xml/xml.dart';

import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/work-number/
class WorkNumber extends XmlElement {
  factory WorkNumber.parse(XmlElement element) {
    return WorkNumber(element.innerText);
  }

  WorkNumber(String content)
      : super.tag(Local.workNumber, children: [XmlText(content)]);
}
