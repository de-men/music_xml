import 'package:music_xml/src/camel_case.dart';
import 'package:xml/xml.dart';

import '../../../attributes/token_attribute.dart';
import '../../../local.dart';
import '../../../music_xml_parser_state.dart';

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

const _barStyleToString = {
  BarStyle.dashed: 'dashed',
  BarStyle.dotted: 'dotted',
  BarStyle.heavy: 'heavy',
  BarStyle.heavyHeavy: 'heavy-heavy',
  BarStyle.heavyLight: 'heavy-light',
  BarStyle.lightHeavy: 'light-heavy',
  BarStyle.lightLight: 'light-light',
  BarStyle.none: 'none',
  BarStyle.regular: 'regular',
  BarStyle.short: 'short',
  BarStyle.tick: 'tick',
};

BarStyle _parseBarStyle(String str) => BarStyle.values.firstWhere(
      (e) => e.toString() == 'BarStyle.' + camelCase(str),
    );

/// Internal representation of a MusicXML `<barline>` element.
class Barline extends XmlElement {
  BarStyle? barStyle;
  TokenAttr? location;

  /// Parse the MusicXML `<barline>` element.
  factory Barline.parse(XmlElement xmlBarline, MusicXMLParserState state) {
    BarStyle? barStyle;
    TokenAttr? location;

    for (final child in xmlBarline.childElements) {
      switch (child.name.local) {
        case 'bar-style':
          barStyle = _parseBarStyle(child.innerText);
          break;
        default:
        // TODO: support remaining <barline> child elements
      }
    }

    for (final attribute in xmlBarline.attributes) {
      final name = attribute.name.local;
      final value = attribute.value;
      switch (name) {
        case 'location':
          location = TokenAttr('location', value);
          break;
        default:
          break;
      }
    }

    return Barline(barStyle, location);
  }

  Barline(this.barStyle, this.location)
      : super.tag(
          Local.barline,
          attributes: [
            if (location != null) location,
          ],
          children: [
            if (barStyle != null)
              XmlElement.tag('bar-style',
                  children: [XmlText(_barStyleToString[barStyle]!)]),
          ],
        );
}
