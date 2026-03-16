import 'package:xml/xml.dart';

import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/staff-layout/
class StaffLayout extends XmlElement {
  final int? number;
  final double? staffDistance;

  factory StaffLayout.parse(XmlElement element) {
    final distance = element.getElement(Local.staffDistance);
    return StaffLayout(
      number: int.tryParse(element.getAttribute('number') ?? ''),
      staffDistance: distance != null ? double.parse(distance.innerText) : null,
    );
  }

  StaffLayout({this.number, this.staffDistance}) : super.tag(Local.staffLayout);
}
