import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/left-center-right/
enum LeftCenterRight { left, center, right }

LeftCenterRight? parseLeftCenterRight(String? str) {
  if (str == null) return null;
  switch (str) {
    case 'left':
      return LeftCenterRight.left;
    case 'center':
      return LeftCenterRight.center;
    case 'right':
      return LeftCenterRight.right;
    default:
      return null;
  }
}

class LeftCenterRightAttr extends XmlAttribute {
  final LeftCenterRight leftCenterRight;

  factory LeftCenterRightAttr.parse(XmlElement element) {
    final value =
        LeftCenterRight.values.firstWhere((e) => e.name == element.innerText);
    return LeftCenterRightAttr(element.name.local, value);
  }

  LeftCenterRightAttr(String name, this.leftCenterRight)
      : super(XmlName(name), leftCenterRight.name);
}
