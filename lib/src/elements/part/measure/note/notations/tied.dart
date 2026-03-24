import 'package:xml/xml.dart';

import '../../../../../attributes/token_attribute.dart';
import '../../../../../data_types/tied_type.dart';
import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/tied/
class Tied extends XmlElement {
  // TODO: support attributes: line-type, dash-length, space-length,
  //       placement, orientation, bezier-*, color, default-x, default-y,
  //       id, relative-x, relative-y
  final TiedType tiedType;
  final TokenAttr? number;

  factory Tied.parse(XmlElement element) {
    final numberAttr = element.getAttribute(Local.number);
    return Tied(
      tiedType: parseTiedType(element.getAttribute(Local.type)!),
      number: numberAttr != null ? TokenAttr(Local.number, numberAttr) : null,
    );
  }

  Tied({required this.tiedType, this.number})
      : super.tag(
          Local.tied,
          attributes: [
            TokenAttr(Local.type, tiedTypeToString[tiedType]!),
            if (number != null) number,
          ],
        );
}
