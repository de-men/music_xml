import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/octave/
class Octave extends XmlElement {
  final int octave;

  factory Octave.parse(XmlElement element) {
    return Octave(int.parse(element.innerText));
  }

  Octave(this.octave) : super.tag(Local.octave);
}
