import 'package:xml/xml.dart';

import '../../../../../data_types/syllabic.dart';
import '../../../../../local.dart';

/// Says whether a `<text>` is a whole word or one syllable of a word.
///
/// Named `LyricSyllabic` and not `Syllabic` so it does not clash with the
/// [Syllabic] value, in the same way as `LyricFont` and `LyricLanguage`.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/syllabic/
class LyricSyllabic extends XmlElement {
  final Syllabic content;

  factory LyricSyllabic.parse(XmlElement element) =>
      LyricSyllabic(parseSyllabic(element.innerText));

  LyricSyllabic(this.content)
    : super.tag(Local.syllabic, children: [XmlText(syllabicToString(content))]);
}
