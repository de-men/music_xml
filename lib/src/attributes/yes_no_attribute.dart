import 'package:xml/xml.dart';

/// Attribute for MusicXML yes-no values.
class YesNoAttr extends XmlAttribute {
  YesNoAttr(String name, bool value)
      : super(XmlName(name), value ? 'yes' : 'no');
}
