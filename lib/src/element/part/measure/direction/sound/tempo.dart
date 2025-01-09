import 'package:xml/xml.dart';

import '../../../../../local.dart';

const defaultQuartersPerMinute = 120.0;

/// Internal representation of a MusicXML tempo.
class Tempo extends XmlAttribute {
  final double nonNegativeDecimal;

  get qpm =>
      nonNegativeDecimal == 0 ? defaultQuartersPerMinute : nonNegativeDecimal;

  /// Parse the MusicXML <sound> element and retrieve the tempo.
  ///
  /// If no tempo is specified, default to DEFAULT_QUARTERS_PER_MINUTE
  factory Tempo.parse(String attribute) {
    var qpm = double.tryParse(attribute) ?? defaultQuartersPerMinute;
    if (qpm == 0) {
      // If tempo is 0, set it to default
      qpm = defaultQuartersPerMinute;
    }

    return Tempo(qpm);
  }

  Tempo(this.nonNegativeDecimal)
      : super(
          XmlName(Local.tempo),
          '$nonNegativeDecimal',
        );
}
