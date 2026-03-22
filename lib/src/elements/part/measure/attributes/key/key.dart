import 'package:music_xml/src/elements/part/measure/attributes/key/fifths.dart';
import 'package:music_xml/src/elements/part/measure/attributes/key/key_accidental.dart';
import 'package:music_xml/src/elements/part/measure/attributes/key/key_alter.dart';
import 'package:music_xml/src/elements/part/measure/attributes/key/key_step.dart';
import 'package:xml/xml.dart';

import '../../../../../local.dart';
import '../../../../../music_xml_parser_state.dart';
import 'mode.dart';

/// Internal representation of a MusicXML key signature.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/key/
class Key extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, font-family,
  //       font-size, font-style, font-weight, id, number, print-object,
  //       relative-x, relative-y
  // TODO: support <cancel> (Optional, before <fifths>)
  final Fifths fifths;
  final Mode? mode;

  /// In this order (Zero or more times)
  /// `<key-step>` (Required)
  /// `<key-alter>` (Required)
  /// `<key-accidental>` (Optional)
  final Iterable<StepAlterAccidental> stepAlterAccidentals;
  // TODO: support <key-octave> (Zero or more times)

  // Extends
  int get key => fifths.fifths;
  final double timePosition;

  factory Key.parse(MusicXMLParserState state, XmlElement element) {
    late final Fifths fifths;
    Mode? mode;
    final stepAlterAccidentals = <StepAlterAccidental>[];
    KeyStep? keyStep;
    KeyAlter? keyAlter;
    KeyAccidental? keyAccidental;

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.fifths:
          fifths = Fifths.parse(child);
          break;
        case Local.mode:
          mode = Mode.parse(child);
          break;
        case Local.keyStep:
          if (keyStep != null) {
            if (keyAlter == null) {
              throw StateError('KeyStep must be followed by KeyAlter');
            }
            stepAlterAccidentals.add(
              StepAlterAccidental(
                keyStep: keyStep,
                keyAlter: keyAlter,
                keyAccidental: keyAccidental,
              ),
            );
          }
          keyStep = KeyStep.parse(child);
          keyAlter = null;
          keyAccidental = null;
          break;
        case Local.keyAlter:
          keyAlter = KeyAlter.parse(child);
          break;
        case Local.keyAccidental:
          keyAccidental = KeyAccidental.parse(child);
          break;
      }
    }

    return Key(
      fifths: fifths,
      mode: mode,
      stepAlterAccidentals: stepAlterAccidentals,
      timePosition: state.timePosition,
    );
  }

  Key({
    required this.fifths,
    this.mode = null,
    this.stepAlterAccidentals = const [],
    this.timePosition = -1,
  }) : super.tag(
          Local.key,
          children: [
            fifths,
            if (mode != null) mode,
            ...stepAlterAccidentals.expand((e) => [
                  e.keyStep,
                  e.keyAlter,
                  if (e.keyAccidental != null) e.keyAccidental!,
                ]),
          ],
        );
}

class StepAlterAccidental {
  final KeyStep keyStep;
  final KeyAlter keyAlter;
  final KeyAccidental? keyAccidental;

  StepAlterAccidental({
    required this.keyStep,
    required this.keyAlter,
    this.keyAccidental,
  });
}
