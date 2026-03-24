import 'package:xml/xml.dart';

import '../../../../attributes/int_attribute.dart';
import '../../../../data_types/beam_value.dart';
import '../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/beam/
class Beam extends XmlElement {
  // TODO: support attributes: color, fan, id, repeater
  final IntAttr? number;
  final BeamValue beamValue;

  factory Beam.parse(XmlElement element) {
    final numberAttr = element.getAttribute(Local.number);
    return Beam(
      number: numberAttr != null
          ? IntAttr(int.parse(numberAttr), Local.number)
          : null,
      beamValue: parseBeamValue(element.innerText),
    );
  }

  Beam({this.number, required this.beamValue})
      : super.tag(
          Local.beam,
          attributes: [if (number != null) number],
          children: [XmlText(beamValueToString[beamValue]!)],
        );
}
