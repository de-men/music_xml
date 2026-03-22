import 'package:xml/xml.dart';

import '../local.dart';

class XLinkTitle extends XmlAttribute {
  XLinkTitle(String title) : super(XmlName(Local.xlinkTitle), title);

  factory XLinkTitle.parse(String value) => XLinkTitle(value);
}
