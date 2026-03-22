import 'package:xml/xml.dart';

import '../data_types/xlink.dart';
import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/xlink-type/
class XLinkTypeAttr extends XmlAttribute {
  XLinkTypeAttr() : super(XmlName(Local.xlinkType), XLinkType.simple.name);

  factory XLinkTypeAttr.parse(String value) {
    if (value != XLinkType.simple.name) {
      throw FormatException(
        'Invalid xlink:type "$value". MusicXML only supports "simple".',
      );
    }
    return XLinkTypeAttr();
  }
}
