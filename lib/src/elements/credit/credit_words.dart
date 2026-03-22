import 'package:xml/xml.dart';

import '../../attributes/decimal_attribute.dart';
import '../../attributes/int_attribute.dart';
import '../../attributes/token_attribute.dart';
import '../../data_types/enclosure_shape.dart';
import '../../data_types/font_size.dart';
import '../../data_types/font_style.dart';
import '../../data_types/font_weight.dart';
import '../../data_types/left_center_right.dart';
import '../../data_types/text_direction.dart';
import '../../data_types/valign.dart';
import '../../data_types/xml_space.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/credit-words/
class CreditWords extends XmlElement {
  final String content;
  final TokenAttr? color;
  final DecimalAttr? defaultX;
  final DecimalAttr? defaultY;
  final DecimalAttr? relativeX;
  final DecimalAttr? relativeY;
  final TokenAttr? fontFamily;
  final FontSizeAttr? fontSize;
  final FontStyleAttr? fontStyle;
  final FontWeightAttr? fontWeight;
  final LeftCenterRightAttr? halign;
  final ValignAttr? valign;
  final LeftCenterRightAttr? justify;
  final EnclosureShapeAttr? enclosure;
  final TextDirectionAttr? dir;
  final TokenAttr? letterSpacing;
  final TokenAttr? lineHeight;
  final IntAttr? lineThrough;
  final IntAttr? overline;
  final IntAttr? underline;
  final DecimalAttr? rotation;
  final TokenAttr? lang;
  final XmlSpaceAttr? space;
  final TokenAttr? creditWordsId;

  factory CreditWords.parse(XmlElement element) {
    TokenAttr? color;
    DecimalAttr? defaultX;
    DecimalAttr? defaultY;
    DecimalAttr? relativeX;
    DecimalAttr? relativeY;
    TokenAttr? fontFamily;
    FontSizeAttr? fontSize;
    FontStyleAttr? fontStyle;
    FontWeightAttr? fontWeight;
    LeftCenterRightAttr? halign;
    ValignAttr? valign;
    LeftCenterRightAttr? justify;
    EnclosureShapeAttr? enclosure;
    TextDirectionAttr? dir;
    TokenAttr? letterSpacing;
    TokenAttr? lineHeight;
    IntAttr? lineThrough;
    IntAttr? overline;
    IntAttr? underline;
    DecimalAttr? rotation;
    TokenAttr? lang;
    XmlSpaceAttr? space;
    TokenAttr? creditWordsId;

    for (final attr in element.attributes) {
      final name = attr.name.qualified;
      final v = attr.value;
      switch (name) {
        case Local.color:
          color = TokenAttr(name, v);
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
        case Local.fontFamily:
          fontFamily = TokenAttr(name, v);
          break;
        case Local.fontSize:
          fontSize = FontSizeAttr(name, FontSize.parse(v));
          break;
        case Local.fontStyle:
          final parsed = parseFontStyle(v);
          if (parsed != null) fontStyle = FontStyleAttr(name, parsed);
          break;
        case Local.fontWeight:
          final parsed = parseFontWeight(v);
          if (parsed != null) fontWeight = FontWeightAttr(name, parsed);
          break;
        case Local.halign:
          final parsed = parseLeftCenterRight(v);
          if (parsed != null) halign = LeftCenterRightAttr(name, parsed);
          break;
        case Local.valign:
          final parsed = parseValign(v);
          if (parsed != null) valign = ValignAttr(name, parsed);
          break;
        case Local.justify:
          final parsed = parseLeftCenterRight(v);
          if (parsed != null) justify = LeftCenterRightAttr(name, parsed);
          break;
        case Local.enclosure:
          final parsed = parseEnclosureShape(v);
          if (parsed != null) enclosure = EnclosureShapeAttr(name, parsed);
          break;
        case Local.dir:
          final parsed = parseTextDirection(v);
          if (parsed != null) dir = TextDirectionAttr(name, parsed);
          break;
        case Local.letterSpacing:
          letterSpacing = TokenAttr(name, v);
          break;
        case Local.lineHeight:
          lineHeight = TokenAttr(name, v);
          break;
        case Local.lineThrough:
          lineThrough = IntAttr(int.parse(v), name);
          break;
        case Local.overline:
          overline = IntAttr(int.parse(v), name);
          break;
        case Local.underline:
          underline = IntAttr(int.parse(v), name);
          break;
        case Local.rotation:
          rotation = DecimalAttr(double.parse(v), name);
          break;
        case Local.xmlLang:
          lang = TokenAttr(name, v);
          break;
        case Local.xmlSpace:
          final parsed = parseXmlSpace(v);
          if (parsed != null) space = XmlSpaceAttr(name, parsed);
          break;
        case Local.id:
          creditWordsId = TokenAttr(name, v);
          break;
      }
    }

    return CreditWords(
      content: element.innerText,
      color: color,
      defaultX: defaultX,
      defaultY: defaultY,
      relativeX: relativeX,
      relativeY: relativeY,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      halign: halign,
      valign: valign,
      justify: justify,
      enclosure: enclosure,
      dir: dir,
      letterSpacing: letterSpacing,
      lineHeight: lineHeight,
      lineThrough: lineThrough,
      overline: overline,
      underline: underline,
      rotation: rotation,
      lang: lang,
      space: space,
      creditWordsId: creditWordsId,
    );
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
  }) : super.tag(
          Local.creditWords,
          attributes: [
            if (color != null) color,
            if (defaultX != null) defaultX,
            if (defaultY != null) defaultY,
            if (relativeX != null) relativeX,
            if (relativeY != null) relativeY,
            if (fontFamily != null) fontFamily,
            if (fontSize != null) fontSize,
            if (fontStyle != null) fontStyle,
            if (fontWeight != null) fontWeight,
            if (halign != null) halign,
            if (valign != null) valign,
            if (justify != null) justify,
            if (enclosure != null) enclosure,
            if (dir != null) dir,
            if (letterSpacing != null) letterSpacing,
            if (lineHeight != null) lineHeight,
            if (lineThrough != null) lineThrough,
            if (overline != null) overline,
            if (underline != null) underline,
            if (rotation != null) rotation,
            if (lang != null) lang,
            if (space != null) space,
            if (creditWordsId != null) creditWordsId,
          ],
          children: [XmlText(content)],
        );
}
