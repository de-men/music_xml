import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/xml-space/
enum XmlSpace { defaultSpace, preserve }

XmlSpace? parseXmlSpace(String? str) {
  if (str == null) return null;
  switch (str) {
    case 'default':
      return XmlSpace.defaultSpace;
    case 'preserve':
      return XmlSpace.preserve;
    default:
      return null;
  }
}

String serializeXmlSpace(XmlSpace space) {
  switch (space) {
    case XmlSpace.defaultSpace:
      return 'default';
    case XmlSpace.preserve:
      return 'preserve';
  }
}

class XmlSpaceAttr extends XmlAttribute {
  final XmlSpace xmlSpace;

  XmlSpaceAttr(String name, this.xmlSpace)
      : super(XmlName(name), serializeXmlSpace(xmlSpace));
}
