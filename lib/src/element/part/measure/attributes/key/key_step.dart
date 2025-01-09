import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

enum Step {
  A,
  B,
  C,
  D,
  E,
  F,
  G,
}

class KeyStep extends XmlElement {
  final Step step;

  factory KeyStep.parse(XmlElement element) {
    late final Step step;
    switch (element.innerText) {
      case 'A':
        step = Step.A;
        break;
      case 'B':
        step = Step.B;
        break;
      case 'C':
        step = Step.C;
        break;
      case 'D':
        step = Step.D;
        break;
      case 'E':
        step = Step.E;
        break;
      case 'F':
        step = Step.F;
        break;
      case 'G':
        step = Step.G;
        break;
      default:
        throw Exception('Unknown key step: ${element.innerText}');
    }
    return KeyStep(step);
  }

  KeyStep(this.step) : super(XmlName(Local.keyStep));
}
