import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/chromatic/
class Chromatic extends XmlElement {
  final int semitones;

  factory Chromatic.parse(XmlElement element) {
    return Chromatic(int.parse(element.innerText));
  }

  Chromatic(this.semitones) : super(XmlName(Local.chromatic));
}
