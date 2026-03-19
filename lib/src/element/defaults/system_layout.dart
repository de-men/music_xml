import 'package:xml/xml.dart';

import '../../basic_attributes.dart';
import '../../data_type/font_size.dart';
import '../../data_type/font_style.dart';
import '../../data_type/font_weight.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/left-divider/
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/right-divider/
class Divider extends XmlElement {
  final bool printObject;
  final String? color;
  final double? defaultX;
  final double? defaultY;
  final double? relativeX;
  final double? relativeY;
  final String? fontFamily;
  final FontSize? fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final String? halign;
  final String? valign;

  factory Divider.parseLeft(XmlElement element) =>
      Divider._parse(Local.leftDivider, element);

  factory Divider.parseRight(XmlElement element) =>
      Divider._parse(Local.rightDivider, element);

  factory Divider._parse(String tag, XmlElement element) {
    return Divider._(
      tag,
      printObject: parseYesNo(element.getAttribute('print-object') ?? 'yes'),
      color: element.getAttribute('color'),
      defaultX: _optDouble(element, 'default-x'),
      defaultY: _optDouble(element, 'default-y'),
      relativeX: _optDouble(element, 'relative-x'),
      relativeY: _optDouble(element, 'relative-y'),
      fontFamily: element.getAttribute('font-family'),
      fontSize: _optFontSize(element),
      fontStyle: parseFontStyle(element.getAttribute('font-style')),
      fontWeight: parseFontWeight(element.getAttribute('font-weight')),
      halign: element.getAttribute('halign'),
      valign: element.getAttribute('valign'),
    );
  }

  static double? _optDouble(XmlElement e, String attr) {
    final v = e.getAttribute(attr);
    return v != null ? double.tryParse(v) : null;
  }

  static FontSize? _optFontSize(XmlElement e) {
    final v = e.getAttribute('font-size');
    return v != null ? FontSize.parse(v) : null;
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
  }) : super.tag(tag);
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
  final double leftMargin;
  final double rightMargin;

  factory SystemMargins.parse(XmlElement element) {
    return SystemMargins(
      leftMargin: double.parse(
        element.getElement('left-margin')?.innerText ?? '0',
      ),
      rightMargin: double.parse(
        element.getElement('right-margin')?.innerText ?? '0',
      ),
    );
  }

  SystemMargins({required this.leftMargin, required this.rightMargin})
      : super.tag(Local.systemMargins);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/system-layout/
class SystemLayout extends XmlElement {
  final SystemMargins? systemMargins;
  final double? systemDistance;
  final double? topSystemDistance;
  final SystemDividers? systemDividers;

  factory SystemLayout.parse(XmlElement element) {
    final margins = element.getElement(Local.systemMargins);
    final dividers = element.getElement(Local.systemDividers);
    return SystemLayout(
      systemMargins: margins != null ? SystemMargins.parse(margins) : null,
      systemDistance: _optDouble(element, Local.systemDistance),
      topSystemDistance: _optDouble(element, Local.topSystemDistance),
      systemDividers: dividers != null ? SystemDividers.parse(dividers) : null,
    );
  }

  static double? _optDouble(XmlElement parent, String name) {
    final el = parent.getElement(name);
    return el != null ? double.parse(el.innerText) : null;
  }

  SystemLayout({
    this.systemMargins,
    this.systemDistance,
    this.topSystemDistance,
    this.systemDividers,
  }) : super.tag(Local.systemLayout);
}
