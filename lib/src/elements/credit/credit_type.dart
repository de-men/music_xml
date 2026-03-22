import 'package:xml/xml.dart';

import '../../local.dart';

/// Standard values for `<credit-type>` element content.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/credit-type/
enum CreditTypeValue {
  pageNumber,
  title,
  subtitle,
  composer,
  arranger,
  lyricist,
  rights,
  partName,
  other,
}

const _creditTypeValueMap = {
  'page number': CreditTypeValue.pageNumber,
  'title': CreditTypeValue.title,
  'subtitle': CreditTypeValue.subtitle,
  'composer': CreditTypeValue.composer,
  'arranger': CreditTypeValue.arranger,
  'lyricist': CreditTypeValue.lyricist,
  'rights': CreditTypeValue.rights,
  'part name': CreditTypeValue.partName,
};

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/credit-type/
class CreditType extends XmlElement {
  final CreditTypeValue content;

  factory CreditType.parse(XmlElement element) {
    final creditTypeValue =
        _creditTypeValueMap[element.innerText] ?? CreditTypeValue.other;
    return CreditType(
      content: creditTypeValue,
      text: element.innerText,
    );
  }

  CreditType({required this.content, required String text})
      : super.tag(Local.creditType, children: [XmlText(text)]);
}
