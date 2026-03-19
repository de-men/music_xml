import 'package:xml/xml.dart';

import '../../attributes/xlink_actuate.dart';
import '../../attributes/xlink_href.dart';
import '../../attributes/xlink_role.dart';
import '../../attributes/xlink_show.dart';
import '../../attributes/xlink_title.dart';
import '../../attributes/xlink_type.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/opus-reference/
///
/// The `<opus>` element represents a link to a MusicXML opus document
/// that composes multiple MusicXML scores into a collection.
/// Always empty, with XLink attributes.
class Opus extends XmlElement {
  final XLinkHref href;
  final XLinkActuateAttr? actuate;
  final XLinkRole? role;
  final XLinkShowAttr? show;
  final XLinkTitle? title;
  final XLinkTypeAttr? type;

  factory Opus.parse(XmlElement element) {
    final href = element.getAttribute('xlink:href') ?? '';
    final actuate = element.getAttribute('xlink:actuate');
    final role = element.getAttribute('xlink:role');
    final show = element.getAttribute('xlink:show');
    final title = element.getAttribute('xlink:title');
    final type = element.getAttribute('xlink:type');

    return Opus(
      href: XLinkHref(href),
      actuate: actuate != null ? XLinkActuateAttr.parse(actuate) : null,
      role: role != null ? XLinkRole(role) : null,
      show: show != null ? XLinkShowAttr.parse(show) : null,
      title: title != null ? XLinkTitle(title) : null,
      type: type != null ? XLinkTypeAttr.parse(type) : null,
    );
  }

  Opus({
    required this.href,
    this.actuate,
    this.role,
    this.show,
    this.title,
    this.type,
  }) : super.tag(
          Local.opus,
          attributes: [
            href,
            if (actuate != null) actuate,
            if (role != null) role,
            if (show != null) show,
            if (title != null) title,
            if (type != null) type,
          ],
        );
}
