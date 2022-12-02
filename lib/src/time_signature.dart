import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

/// Internal representation of a MusicXML time signature.
/// Does not support:
/// - Composite time signatures: 3+2/8
/// - Alternating time signatures 2/4 + 3/8
/// - Senza misura
class TimeSignature {
  int numerator;
  int denominator;
  int divisions;
  double timePosition;

  TimeSignature({
    required this.divisions,
    this.numerator = -1,
    this.denominator = -1,
    this.timePosition = 0,
  });

  int get beats => numerator ~/ divisions;
  int get beatType => denominator ~/ divisions;

  /// Parse the MusicXML <time> element.
  factory TimeSignature.parse(MusicXMLParserState state,
      [XmlElement? xmlTime]) {
    int numerator = -1;
    int denominator = -1;

    double timePosition = 0;

    if (xmlTime != null) {
      if (xmlTime.findAllElements('beats').length > 1 ||
          xmlTime.findAllElements('beat-type').length > 1) {
        // If more than 1 beats or beat-type found, this time signature is
        // not supported (ex: alternating meter)
        throw Exception('Alternating Time Signature');
      }

      final beats = xmlTime.getElement('beats')?.text;
      final beatType = xmlTime.getElement('beat-type')?.text;
      try {
        numerator = int.parse(beats!);
        denominator = int.parse(beatType!);
      } catch (e) {
        throw Exception('Could not parse time signature: $beats/$beatType');
      }

      timePosition = state.timePosition;
    }

    return TimeSignature(
      divisions: state.divisions,
      numerator: numerator,
      denominator: denominator,
      timePosition: timePosition,
    );
  }
}
