import 'package:xml/xml.dart';

import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/xsd-anyURI/
class XLinkHref extends XmlAttribute {
  XLinkHref(String href) : super(XmlName(Local.xlinkHref), href);

  factory XLinkHref.parse(String value) => XLinkHref(value);
}
