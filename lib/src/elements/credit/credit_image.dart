import 'package:xml/xml.dart';

import '../../attributes/decimal_attribute.dart';
import '../../attributes/token_attribute.dart';
import '../../data_types/left_center_right.dart';
import '../../data_types/valign.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/credit-image/
class CreditImage extends XmlElement {
  final TokenAttr? source;
  final TokenAttr? imageType;
  final DecimalAttr? defaultX;
  final DecimalAttr? defaultY;
  final DecimalAttr? relativeX;
  final DecimalAttr? relativeY;
  final LeftCenterRightAttr? halign;
  final ValignImageAttr? valign;
  final DecimalAttr? height;
  final DecimalAttr? width;
  final TokenAttr? imageId;

  factory CreditImage.parse(XmlElement element) {
    TokenAttr? source;
    TokenAttr? imageType;
    DecimalAttr? defaultX;
    DecimalAttr? defaultY;
    DecimalAttr? relativeX;
    DecimalAttr? relativeY;
    LeftCenterRightAttr? halign;
    ValignImageAttr? valign;
    DecimalAttr? height;
    DecimalAttr? width;
    TokenAttr? imageId;

    for (final attr in element.attributes) {
      final name = attr.name.local;
      final v = attr.value;
      switch (name) {
        case Local.source:
          source = TokenAttr(name, v);
          break;
        case Local.type:
          imageType = TokenAttr(name, v);
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
        case Local.halign:
          final parsed = parseLeftCenterRight(v);
          if (parsed != null) halign = LeftCenterRightAttr(name, parsed);
          break;
        case Local.valign:
          final parsed = parseValignImage(v);
          if (parsed != null) valign = ValignImageAttr(name, parsed);
          break;
        case Local.height:
          height = DecimalAttr(double.parse(v), name);
          break;
        case Local.width:
          width = DecimalAttr(double.parse(v), name);
          break;
        case Local.id:
          imageId = TokenAttr(name, v);
          break;
      }
    }

    return CreditImage(
      source: source,
      imageType: imageType,
      defaultX: defaultX,
      defaultY: defaultY,
      relativeX: relativeX,
      relativeY: relativeY,
      halign: halign,
      valign: valign,
      height: height,
      width: width,
      imageId: imageId,
    );
  }

  CreditImage({
    this.source,
    this.imageType,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.halign,
    this.valign,
    this.height,
    this.width,
    this.imageId,
  }) : super.tag(
          Local.creditImage,
          attributes: [
            if (source != null) source,
            if (imageType != null) imageType,
            if (defaultX != null) defaultX,
            if (defaultY != null) defaultY,
            if (relativeX != null) relativeX,
            if (relativeY != null) relativeY,
            if (halign != null) halign,
            if (valign != null) valign,
            if (height != null) height,
            if (width != null) width,
            if (imageId != null) imageId,
          ],
        );
}
