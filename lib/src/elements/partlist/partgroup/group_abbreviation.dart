import 'package:xml/xml.dart';

import '../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/group-abbreviation/
class GroupAbbreviation extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, font-family,
  //       font-size, font-style, font-weight, justify, relative-x, relative-y
  final String content;

  factory GroupAbbreviation.parse(XmlElement element) {
    return GroupAbbreviation(element.innerText);
  }

  GroupAbbreviation(this.content)
      : super.tag(Local.groupAbbreviation, children: [XmlText(content)]);
}
