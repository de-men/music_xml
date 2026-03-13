import 'package:xml/xml.dart';

import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/miscellaneous-field/
class MiscellaneousField extends XmlElement {
  final String fieldName;
  final String value;

  factory MiscellaneousField.parse(XmlElement element) {
    return MiscellaneousField(
      fieldName: element.getAttribute('name') ?? '',
      value: element.innerText,
    );
  }

  MiscellaneousField({required this.fieldName, required this.value})
      : super.tag(Local.miscellaneousField);
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
