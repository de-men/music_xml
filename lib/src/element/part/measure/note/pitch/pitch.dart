import 'package:xml/xml.dart';

import 'alter.dart';
import 'octave.dart';
import 'step.dart';
import '../../../../../local.dart';
import '../../../../../data_types/step.dart' as dt;

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

  static const _stepToPitchClass = {
    dt.Step.C: 0,
    dt.Step.D: 2,
    dt.Step.E: 4,
    dt.Step.F: 5,
    dt.Step.G: 7,
    dt.Step.A: 9,
    dt.Step.B: 11,
  };

  /// Compute MIDI pitch number (C4 = 60, C1 = 24, C0 = 12).
  int toMidiPitch({int transpose = 0}) {
    final alterValue = alter?.alter ?? 0.0;
    var pitchClass = (_stepToPitchClass[step.step]! + alterValue.toInt()) % 12;
    return (12 + pitchClass) + (octave.octave * 12) + transpose;
  }

  /// Human-readable pitch string like "Bb4", "C#5", "G3".
  String toPitchString() {
    final alterValue = alter?.alter ?? 0.0;
    final alterSemitones = alterValue.toInt();
    final isMicrotonal = alterValue != alterSemitones;

    var alterStr = '';
    if (alterSemitones == -2) {
      alterStr = 'bb';
    } else if (alterSemitones == -1) {
      alterStr = 'b';
    } else if (alterSemitones == 1) {
      alterStr = '#';
    } else if (alterSemitones == 2) {
      alterStr = 'x';
    }
    if (isMicrotonal) alterStr += ' (microtones) ';

    return '${step.step.name}$alterStr${octave.octave}';
  }
}
