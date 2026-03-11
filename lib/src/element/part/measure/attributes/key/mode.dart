import 'package:xml/xml.dart';

import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/mode/
class Mode extends XmlElement {
  final String mode;

  factory Mode.parse(XmlElement element) {
    return Mode(element.innerText != 'minor' ? 'major' : 'minor');
  }

  Mode(this.mode) : super(XmlName(Local.mode));
}
