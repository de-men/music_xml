import 'package:xml/xml.dart';

import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/source/
class Source extends XmlElement {
  final String content;

  factory Source.parse(XmlElement element) {
    return Source(element.innerText);
  }

  Source(this.content) : super.tag(Local.source, children: [XmlText(content)]);
}
