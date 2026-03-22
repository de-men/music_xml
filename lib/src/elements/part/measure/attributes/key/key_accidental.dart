import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

import '../../../../../data_types/accidental_value.dart';

export '../../../../../data_types/accidental_value.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/key-accidental/
class KeyAccidental extends XmlElement {
  final AccidentalValue accidentalValue;
  // TODO: support optional smufl attribute (smufl-accidental-glyph-name)

  factory KeyAccidental.parse(XmlElement element) {
    return KeyAccidental(parseAccidentalValue(element.innerText));
  }

  KeyAccidental(this.accidentalValue)
      : super.tag(
          Local.keyAccidental,
          children: [XmlText(accidentalValueToString[accidentalValue]!)],
        );
}
