import 'package:xml/xml.dart';

import '../../basic_attributes.dart';
import '../../attributes/token_attribute.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/encoding-date/
class EncodingDate extends XmlElement {
  factory EncodingDate.parse(XmlElement element) {
    return EncodingDate(element.innerText);
  }

  EncodingDate(String content) : super.tag(Local.encodingDate, children: [XmlText(content)]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/encoder/
class Encoder extends XmlElement {
  String? get type => getAttribute(Local.type);

  factory Encoder.parse(XmlElement element) {
    return Encoder(
      element.innerText,
      type: element.getAttribute(Local.type),
    );
  }

  Encoder(String content, {String? type}) : super.tag(Local.encoder, attributes: [if (type != null) TokenAttr(Local.type, type)], children: [XmlText(content)]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/software/
class Software extends XmlElement {
  factory Software.parse(XmlElement element) {
    return Software(element.innerText);
  }

  Software(String content) : super.tag(Local.software, children: [XmlText(content)]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/encoding-description/
class EncodingDescription extends XmlElement {
  factory EncodingDescription.parse(XmlElement element) {
    return EncodingDescription(element.innerText);
  }

  EncodingDescription(String content) : super.tag(Local.encodingDescription, children: [XmlText(content)]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/supports/
class Supports extends XmlElement {
  final String element;
  final bool type;
  final String? attribute;
  final String? value;

  factory Supports.parse(XmlElement e) {
    late String element;
    late bool type;
    String? attribute;
    String? value;
    for (final child in e.childElements) {
      switch (child.name.local) {
        case Local.element:
          element = child.innerText;
          break;
        case Local.type:
          type = parseYesNo(child.innerText);
          break;
        case Local.attribute:
          attribute = child.innerText;
          break;
        case Local.value:
          value = child.innerText;
          break;
      }
    }
    return Supports(
      element: element,
      type: type,
      attribute: attribute,
      value: value,
    );
  }

  Supports({
    required this.element,
    required this.type,
    this.attribute,
    this.value,
  }) : super.tag(Local.supports, attributes: [TokenAttr(Local.element, element), TokenAttr(Local.type, type ? 'yes' : 'no'), if (attribute != null) TokenAttr(Local.attribute, attribute), if (value != null) TokenAttr(Local.value, value),]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/encoding/
class Encoding extends XmlElement {
  final List<EncodingDate> encodingDates;
  final List<Encoder> encoders;
  final List<Software> software;
  final List<EncodingDescription> encodingDescriptions;
  final List<Supports> supports;

  factory Encoding.parse(XmlElement element) {
    final encodingDates = <EncodingDate>[];
    final encoders = <Encoder>[];
    final software = <Software>[];
    final encodingDescriptions = <EncodingDescription>[];
    final supports = <Supports>[];

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.encodingDate:
          encodingDates.add(EncodingDate.parse(child));
          break;
        case Local.encoder:
          encoders.add(Encoder.parse(child));
          break;
        case Local.software:
          software.add(Software.parse(child));
          break;
        case Local.encodingDescription:
          encodingDescriptions.add(EncodingDescription.parse(child));
          break;
        case Local.supports:
          supports.add(Supports.parse(child));
          break;
      }
    }

    return Encoding(
      encodingDates: encodingDates,
      encoders: encoders,
      software: software,
      encodingDescriptions: encodingDescriptions,
      supports: supports,
    );
  }

  Encoding({
    this.encodingDates = const [],
    this.encoders = const [],
    this.software = const [],
    this.encodingDescriptions = const [],
    this.supports = const [],
  }) : super.tag(Local.encoding);
}
