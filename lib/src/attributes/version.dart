import 'package:xml/xml.dart';

import '../local.dart';

class Version extends XmlAttribute {
  final String value;

  Version(this.value) : super(XmlName(Local.version), value);
}
