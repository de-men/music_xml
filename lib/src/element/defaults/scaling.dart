import 'package:xml/xml.dart';

import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/scaling/
class Scaling extends XmlElement {
  final double millimeters;
  final double tenths;

  factory Scaling.parse(XmlElement element) {
    return Scaling(
      millimeters: double.parse(
        element.getElement(Local.millimeters)!.innerText,
      ),
      tenths: double.parse(element.getElement(Local.tenths)!.innerText),
    );
  }

  Scaling({required this.millimeters, required this.tenths})
      : super.tag(Local.scaling);
}
