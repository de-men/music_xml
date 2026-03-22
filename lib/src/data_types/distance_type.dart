import 'package:xml/xml.dart';

import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/distance-type/
enum DistanceType {
  hyphen,
  beam,
  other,
}

const _distanceTypeMap = {
  'hyphen': DistanceType.hyphen,
  'beam': DistanceType.beam,
};

DistanceType parseDistanceType(String str) =>
    _distanceTypeMap[str] ?? DistanceType.other;

class DistanceTypeAttr extends XmlAttribute {
  final DistanceType distanceType;

  factory DistanceTypeAttr.parse(String typeValue) {
    return DistanceTypeAttr(Local.type, parseDistanceType(typeValue));
  }

  DistanceTypeAttr(String name, this.distanceType)
      : super(XmlName(name), distanceType.name);
}
