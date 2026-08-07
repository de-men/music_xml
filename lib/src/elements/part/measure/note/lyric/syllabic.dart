import 'package:xml/xml.dart';

import '../../../../../data_types/syllabic_value.dart';
import '../../../../../local.dart';

/// Says whether a `<text>` is a whole word or one syllable of a word.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/syllabic/
class Syllabic extends XmlElement {
  final SyllabicValue content;

  factory Syllabic.parse(XmlElement element) =>
      Syllabic(parseSyllabicValue(element.innerText));

  Syllabic(this.content)
    : super.tag(
        Local.syllabic,
        children: [XmlText(syllabicValueToString(content))],
      );
}
