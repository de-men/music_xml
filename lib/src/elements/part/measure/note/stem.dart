import 'package:xml/xml.dart';

import '../../../../data_types/stem_value.dart';
import '../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/stem/
class Stem extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, relative-x,
  //       relative-y
  final StemValue stemValue;

  factory Stem.parse(XmlElement element) {
    return Stem(parseStemValue(element.innerText));
  }

  Stem(this.stemValue)
      : super.tag(
          Local.stem,
          children: [XmlText(stemValueToString[stemValue]!)],
        );
}
