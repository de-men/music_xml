import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/valign/
enum Valign { top, middle, bottom, baseline }

Valign? parseValign(String? str) {
  if (str == null) return null;
  switch (str) {
    case 'top':
      return Valign.top;
    case 'middle':
      return Valign.middle;
    case 'bottom':
      return Valign.bottom;
    case 'baseline':
      return Valign.baseline;
    default:
      return null;
  }
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/valign-image/
enum ValignImage { top, middle, bottom }

ValignImage? parseValignImage(String? str) {
  if (str == null) return null;
  switch (str) {
    case 'top':
      return ValignImage.top;
    case 'middle':
      return ValignImage.middle;
    case 'bottom':
      return ValignImage.bottom;
    default:
      return null;
  }
}

class ValignAttr extends XmlAttribute {
  final Valign valign;

  ValignAttr(String name, this.valign) : super(XmlName(name), valign.name);
}

class ValignImageAttr extends XmlAttribute {
  final ValignImage valignImage;

  factory ValignImageAttr.parse(XmlElement element) {
    return ValignImageAttr(element.name.local,
        ValignImage.values.firstWhere((e) => e.name == element.innerText));
  }

  ValignImageAttr(String name, this.valignImage)
      : super(XmlName(name), valignImage.name);
}
