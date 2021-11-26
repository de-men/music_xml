import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

const defaultQuartersPerMinute = 120.0;

/// Internal representation of a MusicXML tempo.
class Tempo {
  final double qpm;
  final double timePosition;

  Tempo._(this.qpm, this.timePosition);

  /// Parse the MusicXML <sound> element and retrieve the tempo.
  ///
  /// If no tempo is specified, default to DEFAULT_QUARTERS_PER_MINUTE
  factory Tempo.parse(XmlElement xmlSound, MusicXMLParserState state) {
    var qpm = double.tryParse(xmlSound.getElement('tempo')!.text) ??
        defaultQuartersPerMinute;
    if (qpm == 0) {
      // If tempo is 0, set it to default
      qpm = defaultQuartersPerMinute;
    }

    return Tempo._(qpm, state.timePosition);
  }
}
