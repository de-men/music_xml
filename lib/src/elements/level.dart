import 'package:xml/xml.dart';

import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/level/
class Level extends XmlElement {
  // TODO: support attributes: bracket, parentheses, reference, size, type
  final String content;

  factory Level.parse(XmlElement element) {
    return Level(element.innerText);
  }

  Level(this.content) : super.tag(Local.level, children: [XmlText(content)]);
}
