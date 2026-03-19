import 'package:xml/xml.dart';

import '../data_types/xlink.dart';
import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/xlink-show/
class XLinkShowAttr extends XmlAttribute {
  final XLinkShow show;

  static const _showToString = {
    XLinkShow.newWindow: 'new',
    XLinkShow.replace: 'replace',
    XLinkShow.embed: 'embed',
    XLinkShow.other: 'other',
    XLinkShow.none: 'none',
  };

  XLinkShowAttr(this.show)
      : super(XmlName(Local.xlinkShow), _showToString[show]!);

  factory XLinkShowAttr.parse(String value) =>
      XLinkShowAttr(parseXLinkShow(value) ?? XLinkShow.replace);
}
