import 'package:xml/xml.dart';

import '../../data_types/xlink.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/opus-reference/
///
/// The `<opus>` element represents a link to a MusicXML opus document
/// that composes multiple MusicXML scores into a collection.
/// Always empty, with XLink attributes.
class Opus extends XmlElement {
  final String href;
  final XLinkActuate? actuate;
  final String? role;
  final XLinkShow? show;
  final String? title;
  final XLinkType? type;

  factory Opus.parse(XmlElement element) {
    return Opus(
      href: element.getAttribute('xlink:href') ?? '',
      actuate: parseXLinkActuate(element.getAttribute('xlink:actuate')),
      role: element.getAttribute('xlink:role'),
      show: parseXLinkShow(element.getAttribute('xlink:show')),
      title: element.getAttribute('xlink:title'),
      type: parseXLinkType(element.getAttribute('xlink:type')),
    );
  }

  Opus({
    required this.href,
    this.actuate,
    this.role,
    this.show,
    this.title,
    this.type,
  }) : super.tag(Local.opus);
}
