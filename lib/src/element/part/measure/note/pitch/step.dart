import 'package:xml/xml.dart';

import '../../../../../local.dart';
import '../../../../../data_types/step.dart' as dt;

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/step/
class Step extends XmlElement {
  final dt.Step step;

  factory Step.parse(XmlElement element) {
    return Step(dt.parseStep(element.innerText));
  }

  Step(this.step) : super.tag(Local.step);
}
