import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/font-style/
enum FontStyle { normal, italic }

FontStyle? parseFontStyle(String? str) {
  if (str == null) return null;
  switch (str) {
    case 'normal':
      return FontStyle.normal;
    case 'italic':
      return FontStyle.italic;
    default:
      return null;
  }
}

class FontStyleAttr extends XmlAttribute {
  final FontStyle fontStyle;

  factory FontStyleAttr.parse(XmlElement element) {
    return FontStyleAttr(element.name.local,
        FontStyle.values.firstWhere((e) => e.name == element.innerText));
  }

  FontStyleAttr(String name, this.fontStyle)
      : super(XmlName(name), fontStyle.name);
}
