import 'package:xml/xml.dart';

import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/millimeters/
class Millimeters extends XmlElement {
  final double millimeters;

  factory Millimeters.parse(XmlElement element) {
    return Millimeters(double.parse(element.innerText));
  }

  Millimeters(this.millimeters)
      : super.tag(Local.millimeters,
            children: [XmlText(millimeters.toString())]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/tenths/
class Tenths extends XmlElement {
  final double tenths;

  factory Tenths.parse(XmlElement element) {
    return Tenths(double.parse(element.innerText));
  }

  Tenths(this.tenths)
      : super.tag(Local.tenths, children: [XmlText(tenths.toString())]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/scaling/
class Scaling extends XmlElement {
  final Millimeters millimeters;
  final Tenths tenths;

  factory Scaling.parse(XmlElement element) {
    late Millimeters millimeters;
    late Tenths tenths;
    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.millimeters:
          millimeters = Millimeters.parse(child);
          break;
        case Local.tenths:
          tenths = Tenths.parse(child);
          break;
      }
    }
    return Scaling(
      millimeters: millimeters,
      tenths: tenths,
    );
  }

  Scaling({required this.millimeters, required this.tenths})
      : super.tag(Local.scaling, children: [millimeters, tenths]);
}
