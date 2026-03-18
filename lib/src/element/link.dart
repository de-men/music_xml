import 'package:xml/xml.dart';

import '../data_types/xlink.dart';
import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/link/
class Link extends XmlElement {
  final String href;
  final double? defaultX;
  final double? defaultY;
  final double? relativeX;
  final double? relativeY;
  final String? element;
  final String? linkName;
  final int? position;
  final XLinkActuate? actuate;
  final String? role;
  final XLinkShow? show;
  final String? title;
  final XLinkType? type;

  factory Link.parse(XmlElement e) {
    return Link(
      href: e.getAttribute('xlink:href') ?? '',
      defaultX: _optDouble(e, 'default-x'),
      defaultY: _optDouble(e, 'default-y'),
      relativeX: _optDouble(e, 'relative-x'),
      relativeY: _optDouble(e, 'relative-y'),
      element: e.getAttribute('element'),
      linkName: e.getAttribute('name'),
      position: int.tryParse(e.getAttribute('position') ?? ''),
      actuate: parseXLinkActuate(e.getAttribute('xlink:actuate')),
      role: e.getAttribute('xlink:role'),
      show: parseXLinkShow(e.getAttribute('xlink:show')),
      title: e.getAttribute('xlink:title'),
      type: parseXLinkType(e.getAttribute('xlink:type')),
    );
  }

  static double? _optDouble(XmlElement e, String attr) {
    final v = e.getAttribute(attr);
    return v != null ? double.tryParse(v) : null;
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
  }) : super.tag(Local.link);
}
