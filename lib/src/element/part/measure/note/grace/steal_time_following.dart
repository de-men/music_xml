import 'package:xml/xml.dart';

import '../../../../../local.dart';

class StealTimeFollowing extends XmlAttribute {
  final int percent;

  factory StealTimeFollowing.parse(XmlAttribute attribute) {
    return StealTimeFollowing(int.tryParse(attribute.value) ?? 0);
  }

  StealTimeFollowing(this.percent)
    : super(XmlName(Local.stealTimeFollowing), '$percent');
}
