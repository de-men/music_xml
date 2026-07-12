import 'package:xml/xml.dart';

import 'display_octave.dart';
import 'display_step.dart';
import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/unpitched/
class Unpitched extends XmlElement {
  final DisplayStep displayStep;
  final DisplayOctave displayOctave;

  factory Unpitched.parse(XmlElement element) {
    late DisplayStep displayStep;
    late DisplayOctave displayOctave;
    for (final child in element.children) {
      if (child is XmlElement) {
        switch (child.name.local) {
          case Local.displayStep:
            displayStep = DisplayStep.parse(child);
            break;
          case Local.displayOctave:
            displayOctave = DisplayOctave.parse(child);
            break;
        }
      }
    }
    return Unpitched(displayStep: displayStep, displayOctave: displayOctave);
  }

  Unpitched({required this.displayStep, required this.displayOctave})
    : super.tag(Local.unpitched, children: [displayStep, displayOctave]);
}
