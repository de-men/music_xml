import 'package:music_xml/src/basic_attributes.dart';
import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

/// Internal representation of a MusicXML <bass> element.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/bass/
class Bass {
  final Step step;
  final double alter;
  final String? separator;

  /// Parse the MusicXML <bass> element.
  factory Bass.parse(XmlElement xmlBass, MusicXMLParserState state) {
    Step? step;
    double alter = 0.0;
    String? separator;

    // Parse children
    for (final child in xmlBass.childElements) {
      switch (child.name.local) {
        case 'bass-step':
          step = parseStep(child.innerText);
          break;
        case 'bass-alter':
          alter = double.parse(child.innerText);
          break;
        case 'bass-separator':
          separator = child.innerText;
          break;
        default:
        // Ignore other tag types because they are not relevant to Magenta.
      }
    }

    if (step == null) {
      throw XmlParserException('Missing "bass-alter" child element.');
    }

    return Bass(step, alter: alter, separator: separator);
  }

  Bass(this.step, {this.alter = 0.0, this.separator});
}
