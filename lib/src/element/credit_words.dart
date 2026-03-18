import 'package:xml/xml.dart';

import '../data_types/enclosure_shape.dart';
import '../data_types/font_size.dart';
import '../data_types/font_style.dart';
import '../data_types/font_weight.dart';
import '../data_types/left_center_right.dart';
import '../data_types/text_direction.dart';
import '../data_types/valign.dart';
import '../data_types/xml_space.dart';
import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/credit-words/
class CreditWords extends XmlElement {
  final String content;
  final String? color;
  final double? defaultX;
  final double? defaultY;
  final double? relativeX;
  final double? relativeY;
  final String? fontFamily;
  final FontSize? fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final LeftCenterRight? halign;
  final Valign? valign;
  final LeftCenterRight? justify;
  final EnclosureShape? enclosure;
  final TextDirection? dir;
  final String? letterSpacing;
  final String? lineHeight;
  final int? lineThrough;
  final int? overline;
  final int? underline;
  final double? rotation;
  final String? lang;
  final XmlSpace? space;
  final String? creditWordsId;

  factory CreditWords.parse(XmlElement element) {
    final sizeStr = element.getAttribute('font-size');
    return CreditWords(
      content: element.innerText,
      color: element.getAttribute('color'),
      defaultX: _optDouble(element, 'default-x'),
      defaultY: _optDouble(element, 'default-y'),
      relativeX: _optDouble(element, 'relative-x'),
      relativeY: _optDouble(element, 'relative-y'),
      fontFamily: element.getAttribute('font-family'),
      fontSize: sizeStr != null ? FontSize.parse(sizeStr) : null,
      fontStyle: parseFontStyle(element.getAttribute('font-style')),
      fontWeight: parseFontWeight(element.getAttribute('font-weight')),
      halign: parseLeftCenterRight(element.getAttribute('halign')),
      valign: parseValign(element.getAttribute('valign')),
      justify: parseLeftCenterRight(element.getAttribute('justify')),
      enclosure: parseEnclosureShape(element.getAttribute('enclosure')),
      dir: parseTextDirection(element.getAttribute('dir')),
      letterSpacing: element.getAttribute('letter-spacing'),
      lineHeight: element.getAttribute('line-height'),
      lineThrough: _optInt(element, 'line-through'),
      overline: _optInt(element, 'overline'),
      underline: _optInt(element, 'underline'),
      rotation: _optDouble(element, 'rotation'),
      lang: element.getAttribute('xml:lang'),
      space: parseXmlSpace(element.getAttribute('xml:space')),
      creditWordsId: element.getAttribute('id'),
    );
  }

  static double? _optDouble(XmlElement e, String attr) {
    final v = e.getAttribute(attr);
    return v != null ? double.tryParse(v) : null;
  }

  static int? _optInt(XmlElement e, String attr) {
    final v = e.getAttribute(attr);
    return v != null ? int.tryParse(v) : null;
  }

  CreditWords({
    required this.content,
    this.color,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.halign,
    this.valign,
    this.justify,
    this.enclosure,
    this.dir,
    this.letterSpacing,
    this.lineHeight,
    this.lineThrough,
    this.overline,
    this.underline,
    this.rotation,
    this.lang,
    this.space,
    this.creditWordsId,
  }) : super.tag(Local.creditWords);
}
