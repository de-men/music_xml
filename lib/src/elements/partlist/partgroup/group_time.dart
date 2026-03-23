import 'package:xml/xml.dart';

import '../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/group-time/
class GroupTime extends XmlElement {
  factory GroupTime.parse(XmlElement element) {
    return GroupTime();
  }

  GroupTime() : super.tag(Local.groupTime);
}
