import 'package:xml/xml.dart';

import '../../attributes/token_attribute.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/miscellaneous-field/
class MiscellaneousField extends XmlElement {
  final String content;
  final String? fieldName;

  factory MiscellaneousField.parse(XmlElement element) {
    return MiscellaneousField(
      element.innerText,
      fieldName: element.getAttribute(Local.name),
    );
  }

  MiscellaneousField(this.content, {this.fieldName})
      : super.tag(Local.miscellaneousField, attributes: [if (fieldName != null) TokenAttr(Local.name, fieldName)], children: [XmlText(content)]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/miscellaneous/
class Miscellaneous extends XmlElement {
  final List<MiscellaneousField> fields;

  factory Miscellaneous.parse(XmlElement element) {
    final fields = element
        .findElements(Local.miscellaneousField)
        .map((e) => MiscellaneousField.parse(e))
        .toList();
    return Miscellaneous(fields: fields);
  }

  Miscellaneous({this.fields = const []})
      : super.tag(Local.miscellaneous, children: [...fields]);
}
