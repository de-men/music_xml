import 'package:xml/xml.dart';

import '../data_types/accidental_value.dart';
import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/accidental-text/
class AccidentalText extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, dir, enclosure,
  //       font-family, font-size, font-style, font-weight, halign, justify,
  //       letter-spacing, line-height, line-through, overline, relative-x,
  //       relative-y, rotation, smufl, underline, valign, xml:lang, xml:space
  final AccidentalValue accidentalValue;

  factory AccidentalText.parse(XmlElement element) {
    return AccidentalText(parseAccidentalValue(element.innerText));
  }

  AccidentalText(this.accidentalValue)
      : super.tag(
          Local.accidentalText,
          children: [XmlText(accidentalValueToString[accidentalValue]!)],
        );
}
