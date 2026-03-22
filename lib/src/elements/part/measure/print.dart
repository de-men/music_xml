import 'package:music_xml/src/basic_attributes.dart';
import 'package:xml/xml.dart';

import '../../../attributes/decimal_attribute.dart';
import '../../../attributes/int_attribute.dart';
import '../../../attributes/yes_no_attribute.dart';
import '../../../local.dart';
import '../../../music_xml_parser_state.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/print/
class Print extends XmlElement {
  // Attributes
  final IntAttr? blankPage;
  // TODO: support id attribute
  final YesNoAttr? newPage;
  final YesNoAttr? newSystem;
  final IntAttr? pageNumber;
  final DecimalAttr? staffSpacing;

  // TODO: support <page-layout>, <system-layout>, <staff-layout>,
  //       <measure-layout>, <measure-numbering>,
  //       <part-name-display>, <part-abbreviation-display>

  /// Parse the MusicXML `<print>` element.
  factory Print.parse(XmlElement xmlPrint, MusicXMLParserState state) {
    IntAttr? blankPage;
    YesNoAttr? newPage;
    YesNoAttr? newSystem;
    IntAttr? pageNumber;
    DecimalAttr? staffSpacing;

    for (final attribute in xmlPrint.attributes) {
      final name = attribute.name.local;
      final value = attribute.value;
      switch (name) {
        case Local.blankPage:
          blankPage = IntAttr(int.parse(value), name);
          break;
        case Local.newPage:
          newPage = YesNoAttr(name, parseYesNo(value));
          break;
        case Local.newSystem:
          newSystem = YesNoAttr(name, parseYesNo(value));
          break;
        case Local.pageNumber:
          pageNumber = IntAttr(int.parse(value), name);
          break;
        case Local.staffSpacing:
          staffSpacing = DecimalAttr(double.parse(value), name);
          break;
        default:
          break;
      }
    }

    return Print(
      blankPage,
      newPage,
      newSystem,
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
  ) : super.tag(
          Local.print,
          attributes: [
            if (blankPage != null) blankPage,
            if (newPage != null) newPage,
            if (newSystem != null) newSystem,
            if (pageNumber != null) pageNumber,
            if (staffSpacing != null) staffSpacing,
          ],
        );
}
