import 'package:xml/xml.dart';

import '../../../../data_types/rotation_degrees.dart';
import '../../../../local.dart';

/// The stereo position in degrees.
///
/// A value of 0 is center, -90 is hard left, and 90 is hard right.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/pan/
class Pan extends XmlElement {
  final RotationDegrees content;

  factory Pan.parse(XmlElement element) {
    return Pan(RotationDegrees.parse(element.innerText));
  }

  Pan(this.content) : super.tag(Local.pan, children: [XmlText('$content')]);
}
