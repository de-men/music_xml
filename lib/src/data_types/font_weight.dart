import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/font-weight/
enum FontWeight { normal, bold }

FontWeight? parseFontWeight(String? str) {
  if (str == null) return null;
  switch (str) {
    case 'normal':
      return FontWeight.normal;
    case 'bold':
      return FontWeight.bold;
    default:
      return null;
  }
}

class FontWeightAttr extends XmlAttribute {
  final FontWeight fontWeight;

  factory FontWeightAttr.parse(XmlElement element) {
    return FontWeightAttr(element.name.local,
        FontWeight.values.firstWhere((e) => e.name == element.innerText));
  }

  FontWeightAttr(String name, this.fontWeight)
      : super(XmlName(name), fontWeight.name);
}
