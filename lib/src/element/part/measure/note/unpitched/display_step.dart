import 'package:xml/xml.dart';

import '../../../../../local.dart';
import '../../../../../data_type/step.dart' as dt;

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/display-step/
class DisplayStep extends XmlElement {
  final dt.Step step;

  factory DisplayStep.parse(XmlElement element) {
    return DisplayStep(dt.parseStep(element.innerText));
  }

  DisplayStep(this.step) : super.tag(Local.displayStep);
}
