import 'package:xml/xml.dart';

/// Attribute for MusicXML integer values (page, position, line-through, etc.).
class IntAttr extends XmlAttribute {
  final int intValue;

  factory IntAttr.parse(XmlAttribute attribute) {
    return IntAttr(int.parse(attribute.value), attribute.name.local);
  }

  IntAttr(this.intValue, String name) : super(XmlName(name), '$intValue');
}
