import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/key-alter/
class KeyAlter extends XmlElement {
  final double semitones;

  factory KeyAlter.parse(XmlElement element) {
    return KeyAlter(double.parse(element.innerText));
  }

  KeyAlter(this.semitones)
      : super.tag(Local.keyAlter, children: [XmlText('$semitones')]);
}
