import 'package:xml/xml.dart';

import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/voice/
class Voice extends XmlElement {
  final String content;

  factory Voice.parse(XmlElement element) {
    return Voice(element.innerText);
  }

  Voice(this.content) : super.tag(Local.voice, children: [XmlText(content)]);
}
