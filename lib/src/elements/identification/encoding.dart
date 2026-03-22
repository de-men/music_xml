import 'package:xml/xml.dart';

import '../../attributes/token_attribute.dart';
import '../../attributes/yes_no_attribute.dart';
import '../../basic_attributes.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/encoding-date/
class EncodingDate extends XmlElement {
  factory EncodingDate.parse(XmlElement element) {
    return EncodingDate(element.innerText);
  }

  EncodingDate(String content)
      : super.tag(Local.encodingDate, children: [XmlText(content)]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/encoder/
class Encoder extends XmlElement {
  final String content;
  final TokenAttr? type;

  factory Encoder.parse(XmlElement element) {
    final typeStr = element.getAttribute(Local.type);
    return Encoder(
      element.innerText,
      type: typeStr != null ? TokenAttr(Local.type, typeStr) : null,
    );
  }

  Encoder(this.content, {this.type})
      : super.tag(
          Local.encoder,
          attributes: [if (type != null) type],
          children: [XmlText(content)],
        );
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/software/
class Software extends XmlElement {
  final String content;

  factory Software.parse(XmlElement element) {
    return Software(element.innerText);
  }

  Software(this.content)
      : super.tag(Local.software, children: [XmlText(content)]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/encoding-description/
class EncodingDescription extends XmlElement {
  final String content;

  factory EncodingDescription.parse(XmlElement element) {
    return EncodingDescription(element.innerText);
  }

  EncodingDescription(this.content)
      : super.tag(Local.encodingDescription, children: [XmlText(content)]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/supports/
class Supports extends XmlElement {
  final TokenAttr element;
  final YesNoAttr type;
  final TokenAttr? attribute;
  final TokenAttr? valueAttr;

  factory Supports.parse(XmlElement e) {
    late TokenAttr element;
    late YesNoAttr type;
    TokenAttr? attribute;
    TokenAttr? valueAttr;

    for (final attr in e.attributes) {
      final name = attr.name.local;
      final v = attr.value;
      switch (name) {
        case Local.element:
          element = TokenAttr(name, v);
          break;
        case Local.type:
          type = YesNoAttr(name, parseYesNo(v));
          break;
        case Local.attribute:
          attribute = TokenAttr(name, v);
          break;
        case Local.value:
          valueAttr = TokenAttr(name, v);
          break;
      }
    }

    return Supports(
      element: element,
      type: type,
      attribute: attribute,
      valueAttr: valueAttr ?? TokenAttr(Local.value, ''),
    );
  }

  Supports({
    required this.element,
    required this.type,
    this.attribute,
    this.valueAttr,
  }) : super.tag(
          Local.supports,
          attributes: [
            element,
            type,
            if (attribute != null) attribute,
            if (valueAttr != null) valueAttr,
          ],
        );
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
  }) : super.tag(
          Local.encoding,
          children: [
            ...encodingDates,
            ...encoders,
            ...software,
            ...encodingDescriptions,
            ...supports,
          ],
        );
}
