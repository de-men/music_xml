import 'package:xml/xml.dart';

import '../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/staff/
class Staff extends XmlElement {
  final int staffNumber;

  factory Staff.parse(XmlElement element) {
    return Staff(int.parse(element.innerText));
  }

  Staff(this.staffNumber)
      : super.tag(Local.staff, children: [XmlText('$staffNumber')]);
}
