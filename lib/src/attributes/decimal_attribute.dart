import 'package:xml/xml.dart';

/// Attribute for MusicXML decimal (tenths, percent, etc.) values.
class DecimalAttr extends XmlAttribute {
  final double doubleValue;

  factory DecimalAttr.parse(XmlAttribute attribute) {
    return DecimalAttr(double.parse(attribute.value), attribute.name.local);
  }

  DecimalAttr(this.doubleValue, String name)
      : super(XmlName(name), '$doubleValue');
}
