import 'package:xml/xml.dart';

import '../../../../attributes/yes_no_attribute.dart';
import '../../../../basic_attributes.dart';
import '../../../../data_types/accidental_value.dart';
import '../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/accidental/
class Accidental extends XmlElement {
  // TODO: support attributes: bracket, color, default-x,
  //       default-y, font-family, font-size, font-style,
  //       font-weight, parentheses, relative-x, relative-y, size, smufl
  final AccidentalValue accidentalValue;

  /// `cautionary="yes"` shows the accidental in parentheses.
  final bool? cautionary;

  /// `editorial="yes"` shows the accidental as an editorial mark.
  final bool? editorial;

  factory Accidental.parse(XmlElement element) {
    final cautionaryAttr = element.getAttribute(Local.cautionary);
    final editorialAttr = element.getAttribute(Local.editorial);
    return Accidental(
      parseAccidentalValue(element.innerText),
      cautionary: cautionaryAttr != null ? parseYesNo(cautionaryAttr) : null,
      editorial: editorialAttr != null ? parseYesNo(editorialAttr) : null,
    );
  }

  Accidental(this.accidentalValue, {this.cautionary, this.editorial})
    : super.tag(
        Local.accidental,
        attributes: [
          if (cautionary != null) YesNoAttr(Local.cautionary, cautionary),
          if (editorial != null) YesNoAttr(Local.editorial, editorial),
        ],
        children: [XmlText(accidentalValueToString[accidentalValue]!)],
      );
}
