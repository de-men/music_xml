import 'package:xml/xml.dart';

import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/rights/
class Rights extends XmlElement {
  final String? type;
  final String value;

  factory Rights.parse(XmlElement element) {
    return Rights(
      type: element.getAttribute('type'),
      value: element.innerText,
    );
  }

  Rights({this.type, required this.value}) : super.tag(Local.rights);
}
