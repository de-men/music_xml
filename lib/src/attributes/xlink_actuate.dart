import 'package:xml/xml.dart';

import '../data_types/xlink.dart';
import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/xlink-actuate/
class XLinkActuateAttr extends XmlAttribute {
  final XLinkActuate actuate;

  XLinkActuateAttr(this.actuate)
      : super(XmlName(Local.xlinkActuate), actuate.name);

  factory XLinkActuateAttr.parse(String value) =>
      XLinkActuateAttr(parseXLinkActuate(value) ?? XLinkActuate.onRequest);
}
