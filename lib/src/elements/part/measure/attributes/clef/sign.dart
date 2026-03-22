import 'package:xml/xml.dart';

import '../../../../../data_types/clef_sign.dart';
import '../../../../../local.dart';

export '../../../../../data_types/clef_sign.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/sign/
class Sign extends XmlElement {
  final ClefSign content;

  factory Sign.parse(XmlElement element) {
    return Sign(parseClefSign(element.innerText));
  }

  Sign(this.content) : super.tag(Local.sign, children: [XmlText(content.name)]);
}
