import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

class KeyAlter extends XmlElement {
  final double semitones;

  factory KeyAlter.parse(XmlElement element) {
    return KeyAlter(double.parse(element.innerText));
  }

  KeyAlter(this.semitones) : super(XmlName(Local.keyAlter));
}
