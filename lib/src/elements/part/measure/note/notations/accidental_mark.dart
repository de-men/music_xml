import 'package:xml/xml.dart';

import '../../../../../data_types/accidental_value.dart';
import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/accidental-mark/
class AccidentalMark extends XmlElement {
  // TODO: support attributes: bracket, color, default-x, default-y,
  //       font-family, font-size, font-style, font-weight, id,
  //       parentheses, placement, relative-x, relative-y, smufl, type
  final AccidentalValue accidentalValue;

  factory AccidentalMark.parse(XmlElement element) {
    return AccidentalMark(parseAccidentalValue(element.innerText));
  }

  AccidentalMark(this.accidentalValue)
      : super.tag(
          Local.accidentalMark,
          children: [XmlText(accidentalValueToString[accidentalValue]!)],
        );
}
