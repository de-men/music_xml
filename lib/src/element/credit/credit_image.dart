import 'package:xml/xml.dart';

import '../../data_type/left_center_right.dart';
import '../../data_type/valign.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/credit-image/
class CreditImage extends XmlElement {
  final String? source;
  final String? type;
  final double? defaultX;
  final double? defaultY;
  final double? relativeX;
  final double? relativeY;
  final LeftCenterRight? halign;
  final ValignImage? valign;
  final double? height;
  final double? width;
  final String? imageId;

  factory CreditImage.parse(XmlElement element) {
    return CreditImage(
      source: element.getAttribute('source'),
      type: element.getAttribute('type'),
      defaultX: _optDouble(element, 'default-x'),
      defaultY: _optDouble(element, 'default-y'),
      relativeX: _optDouble(element, 'relative-x'),
      relativeY: _optDouble(element, 'relative-y'),
      halign: parseLeftCenterRight(element.getAttribute('halign')),
      valign: parseValignImage(element.getAttribute('valign')),
      height: _optDouble(element, 'height'),
      width: _optDouble(element, 'width'),
      imageId: element.getAttribute('id'),
    );
  }

  static double? _optDouble(XmlElement e, String attr) {
    final v = e.getAttribute(attr);
    return v != null ? double.tryParse(v) : null;
  }

  CreditImage({
    this.source,
    this.type,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.halign,
    this.valign,
    this.height,
    this.width,
    this.imageId,
  }) : super.tag(Local.creditImage);
}
