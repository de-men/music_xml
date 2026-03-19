import 'package:xml/xml.dart';

import '../local.dart';

class StealTimePrevious extends XmlAttribute {
  final int percent;

  factory StealTimePrevious.parse(XmlAttribute attribute) {
    return StealTimePrevious(int.tryParse(attribute.value) ?? 0);
  }

  StealTimePrevious(this.percent)
      : super(XmlName(Local.stealTimePrevious), '$percent');
}
