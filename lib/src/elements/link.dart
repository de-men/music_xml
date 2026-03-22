import 'package:xml/xml.dart';

import '../attributes/decimal_attribute.dart';
import '../attributes/int_attribute.dart';
import '../attributes/token_attribute.dart';
import '../attributes/xlink_actuate.dart';
import '../attributes/xlink_href.dart';
import '../attributes/xlink_role.dart';
import '../attributes/xlink_show.dart';
import '../attributes/xlink_title.dart';
import '../attributes/xlink_type.dart';
import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/link/
class Link extends XmlElement {
  final XLinkHref href;
  final DecimalAttr? defaultX;
  final DecimalAttr? defaultY;
  final DecimalAttr? relativeX;
  final DecimalAttr? relativeY;
  final TokenAttr? element;
  final TokenAttr? linkName;
  final IntAttr? position;
  final XLinkActuateAttr? actuate;
  final XLinkRole? role;
  final XLinkShowAttr? show;
  final XLinkTitle? title;
  final XLinkTypeAttr? type;

  factory Link.parse(XmlElement e) {
    late XLinkHref href;
    DecimalAttr? defaultX;
    DecimalAttr? defaultY;
    DecimalAttr? relativeX;
    DecimalAttr? relativeY;
    TokenAttr? element;
    TokenAttr? linkName;
    IntAttr? position;
    XLinkActuateAttr? actuate;
    XLinkRole? role;
    XLinkShowAttr? show;
    XLinkTitle? title;
    XLinkTypeAttr? type;

    for (final attr in e.attributes) {
      final name = attr.name.qualified;
      final v = attr.value;
      switch (name) {
        case Local.xlinkHref:
          href = XLinkHref(v);
          break;
        case Local.defaultX:
          defaultX = DecimalAttr(double.parse(v), name);
          break;
        case Local.defaultY:
          defaultY = DecimalAttr(double.parse(v), name);
          break;
        case Local.relativeX:
          relativeX = DecimalAttr(double.parse(v), name);
          break;
        case Local.relativeY:
          relativeY = DecimalAttr(double.parse(v), name);
          break;
        case Local.element:
          element = TokenAttr(name, v);
          break;
        case Local.name:
          linkName = TokenAttr(name, v);
          break;
        case Local.position:
          position = IntAttr(int.parse(v), name);
          break;
        case Local.xlinkActuate:
          actuate = XLinkActuateAttr.parse(v);
          break;
        case Local.xlinkRole:
          role = XLinkRole(v);
          break;
        case Local.xlinkShow:
          show = XLinkShowAttr.parse(v);
          break;
        case Local.xlinkTitle:
          title = XLinkTitle(v);
          break;
        case Local.xlinkType:
          type = XLinkTypeAttr.parse(v);
          break;
      }
    }

    return Link(
      href: href,
      defaultX: defaultX,
      defaultY: defaultY,
      relativeX: relativeX,
      relativeY: relativeY,
      element: element,
      linkName: linkName,
      position: position,
      actuate: actuate,
      role: role,
      show: show,
      title: title,
      type: type,
    );
  }

  Link({
    required this.href,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.element,
    this.linkName,
    this.position,
    this.actuate,
    this.role,
    this.show,
    this.title,
    this.type,
  }) : super.tag(
          Local.link,
          attributes: [
            href,
            if (defaultX != null) defaultX,
            if (defaultY != null) defaultY,
            if (relativeX != null) relativeX,
            if (relativeY != null) relativeY,
            if (element != null) element,
            if (linkName != null) linkName,
            if (position != null) position,
            if (actuate != null) actuate,
            if (role != null) role,
            if (show != null) show,
            if (title != null) title,
            if (type != null) type,
          ],
        );
}
