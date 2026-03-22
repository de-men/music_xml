import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/css-font-size/
enum CssFontSize {
  xxSmall,
  xSmall,
  small,
  medium,
  large,
  xLarge,
  xxLarge,
}

const _cssFontSizeMap = {
  'xx-small': CssFontSize.xxSmall,
  'x-small': CssFontSize.xSmall,
  'small': CssFontSize.small,
  'medium': CssFontSize.medium,
  'large': CssFontSize.large,
  'x-large': CssFontSize.xLarge,
  'xx-large': CssFontSize.xxLarge,
};

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/font-size/
///
/// Union type: either a [CssFontSize] or a numeric point size (double).
class FontSize {
  final CssFontSize? cssFontSize;
  final double? numericSize;

  bool get isCss => cssFontSize != null;
  bool get isNumeric => numericSize != null;

  FontSize.css(this.cssFontSize) : numericSize = null;
  FontSize.numeric(this.numericSize) : cssFontSize = null;

  factory FontSize.parse(String str) {
    final css = _cssFontSizeMap[str];
    if (css != null) return FontSize.css(css);
    final numeric = double.tryParse(str);
    if (numeric != null) return FontSize.numeric(numeric);
    return FontSize.css(CssFontSize.medium);
  }

  static const _cssFontSizeToString = {
    CssFontSize.xxSmall: 'xx-small',
    CssFontSize.xSmall: 'x-small',
    CssFontSize.small: 'small',
    CssFontSize.medium: 'medium',
    CssFontSize.large: 'large',
    CssFontSize.xLarge: 'x-large',
    CssFontSize.xxLarge: 'xx-large',
  };

  String toXmlString() {
    if (cssFontSize != null) return _cssFontSizeToString[cssFontSize]!;
    return '$numericSize';
  }
}

class FontSizeAttr extends XmlAttribute {
  final FontSize fontSize;

  factory FontSizeAttr.parse(XmlElement element) {
    return FontSizeAttr(element.name.local, FontSize.parse(element.innerText));
  }

  FontSizeAttr(String name, this.fontSize)
      : super(XmlName(name), fontSize.toXmlString());
}
