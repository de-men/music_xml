import 'package:xml/xml.dart';

import '../local.dart';

class Number extends XmlAttribute {
  final String value;

  Number(this.value) : super(XmlName(Local.number), value);
}
