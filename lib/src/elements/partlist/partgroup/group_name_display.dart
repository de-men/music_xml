import 'package:xml/xml.dart';

import '../../../attributes/yes_no_attribute.dart';
import '../../../basic_attributes.dart';
import '../../../local.dart';
import '../../accidental_text.dart';
import '../../display_text.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/group-name-display/
class GroupNameDisplay extends XmlElement {
  final bool? printObject;
  final List<DisplayText> displayTexts;
  final List<AccidentalText> accidentalTexts;

  factory GroupNameDisplay.parse(XmlElement element) {
    final printObjectAttr = element.getAttribute(Local.printObject);
    final displayTexts = <DisplayText>[];
    final accidentalTexts = <AccidentalText>[];

    element.childElements.forEach((e) {
      switch (e.name.local) {
        case Local.displayText:
          displayTexts.add(DisplayText.parse(e));
          break;
        case Local.accidentalText:
          accidentalTexts.add(AccidentalText.parse(e));
          break;
      }
    });

    return GroupNameDisplay(
      printObject: printObjectAttr != null ? parseYesNo(printObjectAttr) : null,
      displayTexts: displayTexts,
      accidentalTexts: accidentalTexts,
    );
  }

  GroupNameDisplay({
    this.printObject,
    this.displayTexts = const [],
    this.accidentalTexts = const [],
  }) : super.tag(
          Local.groupNameDisplay,
          attributes: [
            if (printObject != null) YesNoAttr(Local.printObject, printObject),
          ],
          children: [...displayTexts, ...accidentalTexts],
        );
}
