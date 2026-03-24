import 'package:xml/xml.dart';

import '../../../../attributes/yes_no_attribute.dart';
import '../../../../basic_attributes.dart';
import '../../../../local.dart';
import 'unpitched/display_octave.dart';
import 'unpitched/display_step.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/rest/
class Rest extends XmlElement {
  final bool? isMeasureRest;
  final DisplayStep? displayStep;
  final DisplayOctave? displayOctave;

  factory Rest.parse(XmlElement element) {
    final measureAttr = element.getAttribute(Local.measure);
    DisplayStep? displayStep;
    DisplayOctave? displayOctave;

    element.childElements.forEach((e) {
      switch (e.name.local) {
        case Local.displayStep:
          displayStep = DisplayStep.parse(e);
          break;
        case Local.displayOctave:
          displayOctave = DisplayOctave.parse(e);
          break;
      }
    });

    return Rest(
      isMeasureRest: measureAttr != null ? parseYesNo(measureAttr) : null,
      displayStep: displayStep,
      displayOctave: displayOctave,
    );
  }

  Rest({this.isMeasureRest, this.displayStep, this.displayOctave})
      : assert((displayStep == null) == (displayOctave == null)),
        super.tag(
          Local.rest,
          attributes: [
            if (isMeasureRest != null) YesNoAttr(Local.measure, isMeasureRest),
          ],
          children: [
            if (displayStep != null) displayStep,
            if (displayOctave != null) displayOctave,
          ],
        );
}
