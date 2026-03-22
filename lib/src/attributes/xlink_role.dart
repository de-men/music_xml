import 'package:xml/xml.dart';

import '../local.dart';

class XLinkRole extends XmlAttribute {
  XLinkRole(String role) : super(XmlName(Local.xlinkRole), role);

  factory XLinkRole.parse(String value) => XLinkRole(value);
}
