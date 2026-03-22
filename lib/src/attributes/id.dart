import 'package:xml/xml.dart';

import '../local.dart';

class Id extends XmlAttribute {
  final String value;

  Id(this.value) : super(XmlName(Local.id), value);
}
