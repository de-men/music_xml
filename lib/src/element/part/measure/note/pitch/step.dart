import 'package:xml/xml.dart';

import '../../../../../local.dart';
import '../../../../../data_types/step.dart' as dt;

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/step/
class Step extends XmlElement {
  final dt.Step step;

  factory Step.parse(XmlElement element) {
    late dt.Step step;
    switch (element.innerText) {
      case 'A':
        step = dt.Step.A;
        break;
      case 'B':
        step = dt.Step.B;
        break;
      case 'C':
        step = dt.Step.C;
        break;
      case 'D':
        step = dt.Step.D;
        break;
      case 'E':
        step = dt.Step.E;
        break;
      case 'F':
        step = dt.Step.F;
        break;
      case 'G':
        step = dt.Step.G;
        break;
    }
    return Step(step);
  }

  Step(this.step) : super.tag(Local.step);
}
