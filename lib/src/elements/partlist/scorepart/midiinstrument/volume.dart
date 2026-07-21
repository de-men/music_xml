import 'package:xml/xml.dart';

import '../../../../data_types/percent.dart';
import '../../../../local.dart';

/// A percentage of the maximum MIDI channel volume.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/volume/
class Volume extends XmlElement {
  final Percent content;

  factory Volume.parse(XmlElement element) {
    return Volume(Percent.parse(element.innerText));
  }

  Volume(this.content)
    : super.tag(Local.volume, children: [XmlText('$content')]);
}
