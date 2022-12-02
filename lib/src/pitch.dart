import 'package:xml/xml.dart';

import 'basic_attributes.dart';

/// Representation of a MusicXml Pitch
class Pitch {
  const Pitch({
    required this.step,
    this.alter = 0.0,
    required this.octave,
  });

  factory Pitch.parse(XmlElement xmlPitch) {
    final step = xmlPitch.getElement('step')!.text;
    final alterText = xmlPitch.getElement('alter')?.text;
    final alter = alterText != null ? double.parse(alterText) : 0.0;
    final octave = int.parse(xmlPitch.getElement('octave')!.text);

    return Pitch(step: parseStep(step), alter: alter, octave: octave);
  }

  final Step step;
  final double alter;
  final int octave;
}
