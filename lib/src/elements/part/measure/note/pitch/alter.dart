import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/alter/
class Alter extends XmlElement {
  final double alter;

  factory Alter.parse(XmlElement element) {
    return Alter(double.parse(element.innerText));
  }

  Alter(this.alter) : super.tag(Local.alter, children: [XmlText('$alter')]);
}
