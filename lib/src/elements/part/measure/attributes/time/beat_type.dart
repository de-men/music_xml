import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/beat-type/
class BeatType extends XmlElement {
  String content;

  factory BeatType.parse(XmlElement element) {
    return BeatType(element.innerText);
  }

  BeatType(this.content)
      : super.tag(Local.beatType, children: [XmlText(content)]);
}
