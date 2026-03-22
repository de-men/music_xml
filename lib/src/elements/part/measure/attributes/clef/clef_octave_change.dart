import 'package:xml/xml.dart';

import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/clef-octave-change/
class ClefOctaveChange extends XmlElement {
  final int integer;

  factory ClefOctaveChange.parse(XmlElement element) {
    return ClefOctaveChange(int.parse(element.innerText));
  }

  ClefOctaveChange(this.integer)
      : super.tag(Local.clefOctaveChange, children: [XmlText('$integer')]);
}
