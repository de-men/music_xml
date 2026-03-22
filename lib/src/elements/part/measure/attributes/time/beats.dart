import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/beats/
class Beats extends XmlElement {
  String content;

  factory Beats.parse(XmlElement element) {
    return Beats(element.innerText);
  }

  Beats(this.content) : super.tag(Local.beats, children: [XmlText(content)]);
}
