import 'package:xml/xml.dart';

import '../../../../../attributes/token_attribute.dart';
import '../../../../../basic_attributes.dart';
import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/tuplet/
class Tuplet extends XmlElement {
  // TODO: support attributes: bracket, show-number, show-type, line-shape,
  //       default-x, default-y, relative-x, relative-y, placement, id
  // TODO: support children: tuplet-actual, tuplet-normal
  final StartStop tupletType;
  final TokenAttr? number;

  factory Tuplet.parse(XmlElement element) {
    final numberAttr = element.getAttribute(Local.number);
    return Tuplet(
      tupletType: parseStartStop(element.getAttribute(Local.type)!),
      number: numberAttr != null ? TokenAttr(Local.number, numberAttr) : null,
    );
  }

  Tuplet({required this.tupletType, this.number})
      : super.tag(
          Local.tuplet,
          attributes: [
            TokenAttr(Local.type, tupletType.name),
            if (number != null) number,
          ],
        );
}
