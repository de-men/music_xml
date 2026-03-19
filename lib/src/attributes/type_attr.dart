import 'package:xml/xml.dart';

/// Reusable `type` attribute (token data type).
/// Used by `<creator>`, `<rights>`, `<relation>`, `<encoder>`, etc.
class TypeAttr extends XmlAttribute {
  TypeAttr(String value) : super(XmlName('type'), value);
}
