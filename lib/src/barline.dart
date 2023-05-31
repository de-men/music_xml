import 'package:music_xml/src/basic_attributes.dart';
import 'package:music_xml/src/camel_case.dart';
import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

enum BarStyle {
  dashed,
  dotted,
  heavy,
  heavyHeavy,
  heavyLight,
  lightHeavy,
  lightLight,
  none,
  regular,
  short,
  tick,
}

BarStyle _parseBarStyle(String str) => BarStyle.values
    .firstWhere((e) => e.toString() == 'BarStyle.' + camelCase(str));

/// Internal representation of a MusicXML <barline> element.
class Barline {
  BarStyle? barStyle;
  RightLeftMiddle? location;

  /// Parse the MusicXML <barline> element.
  factory Barline.parse(XmlElement xmlBarline, MusicXMLParserState state) {
    BarStyle? barStyle;
    RightLeftMiddle? location;

    // Parse children
    for (final child in xmlBarline.childElements) {
      switch (child.name.local) {
        case 'bar-style':
          barStyle = _parseBarStyle(child.innerText);
          break;
        default:
        // Ignore other tag types because they are not relevant to Magenta.
      }
    }

    // Parse attributes
    for (final attribute in xmlBarline.attributes) {
      final name = attribute.name.local;
      final value = attribute.value;
      switch (name) {
        case 'location':
          location = parseRightLeftMiddle(value);
          break;
        default:
          // Add implementation above
          break;
      }
    }

    return Barline(barStyle, location);
  }

  Barline(this.barStyle, this.location);
}
