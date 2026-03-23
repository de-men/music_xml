import 'package:xml/xml.dart';

import '../../../data_types/group_barline_value.dart';
import '../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/group-barline/
class GroupBarline extends XmlElement {
  // TODO: support attribute: color
  final GroupBarlineValue groupBarlineValue;

  factory GroupBarline.parse(XmlElement element) {
    return GroupBarline(parseGroupBarlineValue(element.innerText));
  }

  GroupBarline(this.groupBarlineValue)
      : super.tag(
          Local.groupBarline,
          children: [XmlText(groupBarlineValueToString[groupBarlineValue]!)],
        );
}
