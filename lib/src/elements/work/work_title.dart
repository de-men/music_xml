import 'package:xml/xml.dart';

import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/work-title/
class WorkTitle extends XmlElement {
  factory WorkTitle.parse(XmlElement element) {
    return WorkTitle(element.innerText);
  }

  WorkTitle(String content)
      : super.tag(Local.workTitle, children: [XmlText(content)]);
}
