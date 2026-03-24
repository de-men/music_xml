import 'package:xml/xml.dart';

import '../../../../attributes/token_attribute.dart';
import '../../../../data_types/start_stop.dart';
import '../../../../local.dart';

/// Internal representation of a MusicXML `<tie>` element.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/tie/
class Tie extends XmlElement {
  final StartStopAttr type;
  final TokenAttr? timeOnly;

  factory Tie.parse(XmlElement element) {
    late final StartStopAttr type;
    TokenAttr? timeOnly;

    element.attributes.forEach((e) {
      switch (e.name.local) {
        case Local.type:
          type = StartStopAttr(e.name.local, parseStartStop(e.value));
          break;
        case Local.timeOnly:
          timeOnly = TokenAttr(e.name.local, e.value);
          break;
      }
    });

    return Tie(type: type, timeOnly: timeOnly);
  }

  Tie({required this.type, this.timeOnly})
      : super.tag(
          Local.tie,
          attributes: [
            type,
            if (timeOnly != null) timeOnly,
          ],
        );
}
