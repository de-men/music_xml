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
}
