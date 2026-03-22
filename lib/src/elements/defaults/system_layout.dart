import 'package:xml/xml.dart';

import '../../attributes/decimal_attribute.dart';
import '../../attributes/token_attribute.dart';
import '../../attributes/yes_no_attribute.dart';
import '../../basic_attributes.dart';
import '../../data_types/font_size.dart';
import '../../data_types/font_style.dart';
import '../../data_types/font_weight.dart';
import '../../local.dart';
import 'page_layout.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/system-distance/
class SystemDistance extends XmlElement {
  final double tenths;

  factory SystemDistance.parse(XmlElement element) {
    return SystemDistance(double.parse(element.innerText));
  }

  SystemDistance(this.tenths)
      : super.tag(Local.systemDistance, children: [XmlText('$tenths')]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/top-system-distance/
class TopSystemDistance extends XmlElement {
  final double tenths;

  factory TopSystemDistance.parse(XmlElement element) {
    return TopSystemDistance(double.parse(element.innerText));
  }

  TopSystemDistance(this.tenths)
      : super.tag(Local.topSystemDistance, children: [XmlText('$tenths')]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/left-divider/
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/right-divider/
class Divider extends XmlElement {
  final YesNoAttr printObject;
  final TokenAttr? color;
  final DecimalAttr? defaultX;
  final DecimalAttr? defaultY;
  final DecimalAttr? relativeX;
  final DecimalAttr? relativeY;
  final TokenAttr? fontFamily;
  final FontSizeAttr? fontSize;
  final FontStyleAttr? fontStyle;
  final FontWeightAttr? fontWeight;
  final TokenAttr? halign;
  final TokenAttr? valign;

  factory Divider.parseLeft(XmlElement element) =>
      Divider._parse(Local.leftDivider, element);

  factory Divider.parseRight(XmlElement element) =>
      Divider._parse(Local.rightDivider, element);

  factory Divider._parse(String tag, XmlElement element) {
    late YesNoAttr printObject;
    TokenAttr? color;
    DecimalAttr? defaultX;
    DecimalAttr? defaultY;
    DecimalAttr? relativeX;
    DecimalAttr? relativeY;
    TokenAttr? fontFamily;
    FontSizeAttr? fontSize;
    FontStyleAttr? fontStyle;
    FontWeightAttr? fontWeight;
    TokenAttr? halign;
    TokenAttr? valign;

    var hasPrintObject = false;
    for (final attr in element.attributes) {
      final name = attr.name.local;
      final v = attr.value;
      switch (name) {
        case 'print-object':
          printObject = YesNoAttr(name, parseYesNo(v));
          hasPrintObject = true;
          break;
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
          halign = TokenAttr(name, v);
          break;
        case Local.valign:
          valign = TokenAttr(name, v);
          break;
      }
    }

    if (!hasPrintObject) {
      printObject = YesNoAttr('print-object', true);
    }

    return Divider._(
      tag,
      printObject: printObject,
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
    );
  }

  Divider._(
    String tag, {
    required this.printObject,
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
  }) : super.tag(
          tag,
          attributes: [
            printObject,
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
          ],
        );
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/system-dividers/
class SystemDividers extends XmlElement {
  final Divider leftDivider;
  final Divider rightDivider;

  factory SystemDividers.parse(XmlElement element) {
    return SystemDividers(
      leftDivider: Divider.parseLeft(element.getElement(Local.leftDivider)!),
      rightDivider: Divider.parseRight(element.getElement(Local.rightDivider)!),
    );
  }

  SystemDividers({required this.leftDivider, required this.rightDivider})
      : super.tag(
          Local.systemDividers,
          children: [leftDivider, rightDivider],
        );
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/system-margins/
class SystemMargins extends XmlElement {
  final LeftMargin leftMargin;
  final RightMargin rightMargin;

  factory SystemMargins.parse(XmlElement element) {
    late LeftMargin leftMargin;
    late RightMargin rightMargin;

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.leftMargin:
          leftMargin = LeftMargin.parse(child);
          break;
        case Local.rightMargin:
          rightMargin = RightMargin.parse(child);
          break;
      }
    }

    return SystemMargins(
      leftMargin: leftMargin,
      rightMargin: rightMargin,
    );
  }

  SystemMargins({required this.leftMargin, required this.rightMargin})
      : super.tag(
          Local.systemMargins,
          children: [leftMargin, rightMargin],
        );
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/system-layout/
class SystemLayout extends XmlElement {
  final SystemMargins? systemMargins;
  final SystemDistance? systemDistance;
  final TopSystemDistance? topSystemDistance;
  final SystemDividers? systemDividers;

  factory SystemLayout.parse(XmlElement element) {
    SystemMargins? systemMargins;
    SystemDistance? systemDistance;
    TopSystemDistance? topSystemDistance;
    SystemDividers? systemDividers;

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.systemMargins:
          systemMargins = SystemMargins.parse(child);
          break;
        case Local.systemDistance:
          systemDistance = SystemDistance.parse(child);
          break;
        case Local.topSystemDistance:
          topSystemDistance = TopSystemDistance.parse(child);
          break;
        case Local.systemDividers:
          systemDividers = SystemDividers.parse(child);
          break;
      }
    }

    return SystemLayout(
      systemMargins: systemMargins,
      systemDistance: systemDistance,
      topSystemDistance: topSystemDistance,
      systemDividers: systemDividers,
    );
  }

  SystemLayout({
    this.systemMargins,
    this.systemDistance,
    this.topSystemDistance,
    this.systemDividers,
  }) : super.tag(
          Local.systemLayout,
          children: [
            if (systemMargins != null) systemMargins,
            if (systemDistance != null) systemDistance,
            if (topSystemDistance != null) topSystemDistance,
            if (systemDividers != null) systemDividers,
          ],
        );
}
