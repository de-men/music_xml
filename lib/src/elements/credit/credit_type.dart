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
  final CreditTypeValue creditTypeValue;
  final String content;

  factory CreditType.parse(XmlElement element) {
    final text = element.innerText;
    return CreditType(
      creditTypeValue: _creditTypeValueMap[text] ?? CreditTypeValue.other,
      content: text,
    );
  }

  CreditType({required this.creditTypeValue, required this.content})
      : super.tag(Local.creditType);
}
