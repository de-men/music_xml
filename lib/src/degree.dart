import 'package:music_xml/src/basic_attributes.dart';
import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

/// Internal representation of a MusicXML <degree> element.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/degree/
class Degree {
  final int value;
  final double alter;
  final DegreeType type;

  /// Parse the MusicXML <degree> element.
  factory Degree.parse(XmlElement xmlDegree, MusicXMLParserState state) {
    int? value;
    double? alter;
    dynamic type;

    // Parse children
    for (final child in xmlDegree.childElements) {
      switch (child.name.local) {
        case 'degree-value':
          value = int.parse(child.innerText);
          break;
        case 'degree-alter':
          alter = double.parse(child.innerText);
          break;
        case 'degree-type':
          type = parseDegreeType(child.innerText);
          break;
        default:
        // Ignore other tag types because they are not relevant to Magenta.
      }
    }

    if (alter == null) {
      throw XmlParserException('Missing "degree-alter" child element.');
    }

    if (value == null) {
      throw XmlParserException('Missing "degree-value" child element.');
    }

    if (type == null) {
      throw XmlParserException('Missing "degree-type" child element.');
    }

    return Degree(value, alter, type);
  }

  Degree(this.value, this.alter, this.type);
}
