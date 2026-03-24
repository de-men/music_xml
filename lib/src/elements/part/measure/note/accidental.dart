import 'package:xml/xml.dart';

import '../../../../data_types/accidental_value.dart';
import '../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/accidental/
class Accidental extends XmlElement {
  // TODO: support attributes: bracket, cautionary, color, default-x,
  //       default-y, editorial, font-family, font-size, font-style,
  //       font-weight, parentheses, relative-x, relative-y, size, smufl
  final AccidentalValue accidentalValue;

  factory Accidental.parse(XmlElement element) {
    return Accidental(parseAccidentalValue(element.innerText));
  }

  Accidental(this.accidentalValue)
      : super.tag(
          Local.accidental,
          children: [XmlText(accidentalValueToString[accidentalValue]!)],
        );
}
