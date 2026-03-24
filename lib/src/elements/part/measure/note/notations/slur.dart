import 'package:xml/xml.dart';

import '../../../../../attributes/token_attribute.dart';
import '../../../../../data_types/start_stop_continue.dart';
import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/slur/
class Slur extends XmlElement {
  // TODO: support attributes: line-type, dash-length, space-length,
  //       placement, orientation, bezier-*, color, default-x, default-y,
  //       id, relative-x, relative-y
  final StartStopContinue slurType;
  final TokenAttr? number;

  factory Slur.parse(XmlElement element) {
    final numberAttr = element.getAttribute(Local.number);
    return Slur(
      slurType: parseStartStopContinue(element.getAttribute(Local.type)!),
      number: numberAttr != null ? TokenAttr(Local.number, numberAttr) : null,
    );
  }

  Slur({required this.slurType, this.number})
      : super.tag(
          Local.slur,
          attributes: [
            TokenAttr(Local.type, startStopContinueToString[slurType]!),
            if (number != null) number,
          ],
        );
}
