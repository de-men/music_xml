import 'package:xml/xml.dart';

import '../../basic_attributes.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/supports/
class Supports extends XmlElement {
  final String element;
  final bool type;
  final String? attribute;
  final String? value;

  factory Supports.parse(XmlElement e) {
    return Supports(
      element: e.getAttribute('element') ?? '',
      type: parseYesNo(e.getAttribute('type') ?? 'no'),
      attribute: e.getAttribute('attribute'),
      value: e.getAttribute('value'),
    );
  }

  Supports({
    required this.element,
    required this.type,
    this.attribute,
    this.value,
  }) : super.tag(Local.supports);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/encoder/
class Encoder extends XmlElement {
  final String? type;
  final String value;

  factory Encoder.parse(XmlElement element) {
    return Encoder(
      type: element.getAttribute('type'),
      value: element.innerText,
    );
  }

  Encoder({this.type, required this.value}) : super.tag(Local.encoder);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/encoding/
class Encoding extends XmlElement {
  final List<String> encodingDates;
  final List<Encoder> encoders;
  final List<String> software;
  final List<String> encodingDescriptions;
  final List<Supports> supports;

  factory Encoding.parse(XmlElement element) {
    final encodingDates = <String>[];
    final encoders = <Encoder>[];
    final software = <String>[];
    final encodingDescriptions = <String>[];
    final supports = <Supports>[];

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.encodingDate:
          encodingDates.add(child.innerText);
          break;
        case Local.encoder:
          encoders.add(Encoder.parse(child));
          break;
        case Local.software:
          software.add(child.innerText);
          break;
        case Local.encodingDescription:
          encodingDescriptions.add(child.innerText);
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
