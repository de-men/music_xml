import 'package:music_xml/src/basic_attributes.dart';
import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

/// Internal representation of a MusicXML <tie> element.
class Tie {
  final StartStop type;

  /// Parse the MusicXML <tie> element.
  factory Tie.parse(XmlElement xmlTie, MusicXMLParserState state) {
    StartStop? startStop = _parseType(xmlTie);
    return Tie(startStop);
  }

  Tie(this.type);

  /// Parses a type attribute
  static StartStop _parseType(XmlElement xmlTie) {
    try {
      final value =
          xmlTie.attributes.firstWhere((e) => e.name.local == 'type').value;
      return parseStartStop(value);
    } catch (e) {
      throw throw XmlParserException(
          'Invalid <tie>. "type" attribute missing or invalid.');
    }
  }
}
