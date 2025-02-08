import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/display-octave/
class DisplayOctave extends XmlElement {
  final int octave;

  factory DisplayOctave.parse(XmlElement element) {
    return DisplayOctave(int.parse(element.innerText));
  }

  DisplayOctave(this.octave) : super.tag(Local.displayOctave);
}
