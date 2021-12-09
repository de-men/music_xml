import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

/// Internal representation of a MusicXML key signature.
class KeySignature {
  late int key;
  late String mode;
  late double timePosition;

  KeySignature._();

  factory KeySignature.parse(MusicXMLParserState state, [XmlElement? xmlKey]) {
    final instance = KeySignature._()
      // MIDI and MusicXML identify key by using "fifths":
      // -1 = F, 0 = C, 1 = G etc.
      ..key = 0
      // # mode is "major" or "minor" only: MIDI only supports major and minor
      ..mode = 'major'
      ..timePosition = -1;

    if (xmlKey != null) instance._parse(xmlKey, state);
    return instance;
  }

  /// Parse the MusicXML <key> element into a MIDI compatible key.
  ///
  /// If the mode is not minor (e.g. dorian), default to "major"
  /// because MIDI only supports major and minor modes.
  ///
  /// Raises:
  ///       KeyParseError: If the fifths element is missing.
  void _parse(XmlElement xmlKey, MusicXMLParserState state) {
    final fifths = xmlKey.getElement('fifths');
    if (fifths == null) {
      throw XmlParserException(
          'Could not find fifths attribute in key signature.');
    }
    key = int.parse(fifths.text);
    var mode = xmlKey.getAttribute('mode');
    // # Anything not minor will be interpreted as major
    if (mode != 'minor') mode = 'major';
    this.mode = mode!;
    timePosition = state.timePosition;
  }
}
