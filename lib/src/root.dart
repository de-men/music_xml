import 'package:music_xml/src/basic_attributes.dart';
import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

/// Internal representation of a MusicXML <root> element.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/root/
class Root {
  final Step step;
  final double alter;

  /// Parse the MusicXML <root> element.
  factory Root.parse(XmlElement xmlRoot, MusicXMLParserState state) {
    Step? rootStep;
    double rootAlter = 0.0;

    // Parse children
    for (final child in xmlRoot.childElements) {
      switch (child.name.local) {
        case 'root-step':
          rootStep = parseStep(child.text);
          break;
        case 'root-alter':
          rootAlter = double.parse(child.text);
          break;
        default:
        // Ignore other tag types because they are not relevant to Magenta.
      }
    }

    if (rootStep == null) {
      throw XmlParserException('Missing "root-alter" child element.');
    }

    return Root(rootStep, alter: rootAlter);
  }

  Root(this.step, {this.alter = 0.0});
}
