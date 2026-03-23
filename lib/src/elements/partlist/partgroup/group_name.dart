import 'package:xml/xml.dart';

import '../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/group-name/
class GroupName extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, font-family,
  //       font-size, font-style, font-weight, justify, relative-x, relative-y
  final String content;

  factory GroupName.parse(XmlElement element) {
    return GroupName(element.innerText);
  }

  GroupName(this.content)
      : super.tag(Local.groupName, children: [XmlText(content)]);
}
