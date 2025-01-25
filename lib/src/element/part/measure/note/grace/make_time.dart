import 'package:xml/xml.dart';

import '../../../../../local.dart';

class MakeTime extends XmlAttribute {
  final int divisions;

  factory MakeTime.parse(XmlAttribute attribute) {
    return MakeTime(int.tryParse(attribute.value) ?? 0);
  }

  MakeTime(this.divisions)
      : super(
          XmlName(Local.makeTime),
          '$divisions',
        );
}
