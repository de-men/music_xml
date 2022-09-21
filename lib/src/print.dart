import 'package:music_xml/src/basic_attributes.dart';
import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

/// Internal representation of a MusicXML <print> element.
class Print {
  final int? blankPage;
  bool newPage;
  bool newSystem;
  int? pageNumber;
  double? staffSpacing;

  /// Parse the MusicXML <print> element.
  factory Print.parse(XmlElement xmlPrint, MusicXMLParserState state) {
    int? blankPage;
    bool? newPage;
    bool? newSystem;
    int? pageNumber;
    double? staffSpacing;

    for (final attribute in xmlPrint.attributes) {
      final name = attribute.name.local;
      final value = attribute.value;
      switch (name) {
        case 'blank-page':
          blankPage = int.parse(value);
          break;
        case 'new-page':
          newPage = parseYesNo(value);
          break;
        case 'new-system':
          newSystem = parseYesNo(value);
          break;
        case 'page-number':
          pageNumber = int.parse(value);
          break;
        case 'staff-spacing':
          staffSpacing = double.parse(value);
          break;
        default:
        // Add implementation above
      }
    }

    return Print(
      blankPage,
      newPage ?? false,
      newSystem ?? false,
      pageNumber,
      staffSpacing,
    );
  }

  Print(
    this.blankPage,
    this.newPage,
    this.newSystem,
    this.pageNumber,
    this.staffSpacing,
  );
}
