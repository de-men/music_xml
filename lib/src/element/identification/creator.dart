import 'package:xml/xml.dart';

import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/creator/
class Creator extends XmlElement {
  final String? type;
  final String value;

  factory Creator.parse(XmlElement element) {
    return Creator(
      type: element.getAttribute('type'),
      value: element.innerText,
    );
  }

  Creator({this.type, required this.value}) : super.tag(Local.creator);
}
