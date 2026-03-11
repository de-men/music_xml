import 'package:xml/xml.dart';

import '../../../../../local.dart';

class Dynamics extends XmlAttribute {
  final double nonNegativeDecimal;

  factory Dynamics.parse(String attribute) {
    return Dynamics(double.parse(attribute));
  }

  Dynamics(this.nonNegativeDecimal)
    : super(XmlName(Local.dynamics), '$nonNegativeDecimal');
}
