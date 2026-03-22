import 'package:xml/xml.dart';

/// https://www.w3.org/TR/xmlschema-2/#token
///
/// General-purpose token attribute for simple name-value pairs
/// like `type`, `number`, `name`, etc.
class TokenAttr extends XmlAttribute {
  TokenAttr(String name, String value) : super(XmlName(name), value);
}
