import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/chord/
class Chord extends XmlElement {
  Chord() : super.tag(Local.chord);
}
