import 'package:xml/xml.dart';

import '../data_types/xlink.dart';
import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/xlink-type/
class XLinkTypeAttr extends XmlAttribute {
  final XLinkType type;

  XLinkTypeAttr(this.type) : super(XmlName(Local.xlinkType), 'simple');

  factory XLinkTypeAttr.parse(String value) =>
      XLinkTypeAttr(parseXLinkType(value) ?? XLinkType.simple);
}
