import 'package:xml/xml.dart';

import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/clef-sign/
enum ClefSign { G, F, C, percussion, TAB, jianpu, none }

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/sign/
class Sign extends XmlElement {
  final ClefSign content;

  factory Sign.parse(XmlElement element) {
    final content = element.innerText;
    ClefSign sign;
    switch (content) {
      case 'G':
        sign = ClefSign.G;
        break;
      case 'F':
        sign = ClefSign.F;
        break;
      case 'C':
        sign = ClefSign.C;
        break;
      case 'percussion':
        sign = ClefSign.percussion;
        break;
      case 'TAB':
        sign = ClefSign.TAB;
        break;
      case 'jianpu':
        sign = ClefSign.jianpu;
        break;
      case 'none':
        sign = ClefSign.none;
        break;
      default:
        throw Exception('Unknown clef sign: $content');
    }
    return Sign(sign);
  }

  Sign(this.content) : super(XmlName(Local.sign));
}
