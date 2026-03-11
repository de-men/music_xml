import 'package:xml/xml.dart';

import 'alter.dart';
import 'octave.dart';
import 'step.dart';
import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/pitch/
class Pitch extends XmlElement {
  final Step step;
  final Alter? alter;
  final Octave octave;

  factory Pitch.parse(XmlElement element) {
    late Step step;
    Alter? alter;
    late Octave octave;
    for (final child in element.children) {
      if (child is XmlElement) {
        switch (child.name.local) {
          case Local.step:
            step = Step.parse(child);
            break;
          case Local.alter:
            alter = Alter.parse(child);
            break;
          case Local.octave:
            octave = Octave.parse(child);
            break;
        }
      }
    }
    return Pitch(step: step, alter: alter, octave: octave);
  }

  Pitch({required this.step, this.alter, required this.octave})
      : super.tag(
          Local.pitch,
          children: [step, if (alter != null) alter, octave],
        );
}
