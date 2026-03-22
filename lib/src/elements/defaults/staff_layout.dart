import 'package:xml/xml.dart';

import '../../attributes/int_attribute.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/staff-distance/
class StaffDistance extends XmlElement {
  final double tenths;

  factory StaffDistance.parse(XmlElement element) {
    return StaffDistance(double.parse(element.innerText));
  }

  StaffDistance(this.tenths)
      : super.tag(Local.staffDistance, children: [XmlText('$tenths')]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/staff-layout/
class StaffLayout extends XmlElement {
  final IntAttr? number;
  final StaffDistance? staffDistance;

  factory StaffLayout.parse(XmlElement element) {
    final numberAttr = element.getAttribute(Local.number);
    final parsedNumber = numberAttr != null ? int.tryParse(numberAttr) : null;
    StaffDistance? staffDistance;

    for (final child in element.childElements) {
      if (child.name.local == Local.staffDistance) {
        staffDistance = StaffDistance.parse(child);
      }
    }

    return StaffLayout(
      number: parsedNumber != null ? IntAttr(parsedNumber, Local.number) : null,
      staffDistance: staffDistance,
    );
  }

  StaffLayout({this.number, this.staffDistance})
      : super.tag(
          Local.staffLayout,
          attributes: [if (number != null) number],
          children: [if (staffDistance != null) staffDistance],
        );
}
