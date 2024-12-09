import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

/// Internal representation of a MusicXML clef signature.
class ClefSignature {
  // The <sign> element represents the clef symbol
  late String sign;
  // Line numbers are counted from the bottom of the staff. They are only needed with the G, F, and C signs in order to position a pitch correctly on the staff. Standard values are 2 for the G sign (treble clef), 4 for the F sign (bass clef), and 3 for the C sign (alto clef). Line values can be used to specify positions outside the staff, such as a C clef positioned in the middle of a grand staff.
  int? line;
  // The <clef-octave-change> element is used for transposing clefs. A treble clef for tenors would have a value of -1.
  int? clefOctaveChange;

  ClefSignature();

  factory ClefSignature.parse(MusicXMLParserState state, [XmlElement? xmlKey]) {
    final instance = ClefSignature()..sign = '';

    if (xmlKey != null) instance._parse(xmlKey, state);
    return instance;
  }

  /// Parse the MusicXML <clef> element.
  ///
  /// Raises:
  ///       KeyParseError: If the sign element is missing.
  void _parse(XmlElement xmlKey, MusicXMLParserState state) {
    // parse sign
    final signElem = xmlKey.getElement('sign');
    if (signElem == null) {
      throw XmlParserException(
          'Could not find sign element in clef signature.');
    }
    sign = signElem.innerText;

    // parse line
    final lineElem = xmlKey.getElement('line');
    if (lineElem != null && lineElem.innerText.isNotEmpty) {
      line = int.parse(lineElem.innerText);
    }

    // parse clefOctaveChange
    final cocElem = xmlKey.getElement('clef-octave-change');
    if (cocElem != null && cocElem.innerText.isNotEmpty) {
      clefOctaveChange = int.parse(cocElem.innerText);
    }
  }
}
