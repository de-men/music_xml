import 'package:xml/xml.dart';

import '../../../../../data_types/step.dart';
import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/key-step/
class KeyStep extends XmlElement {
  final Step step;

  factory KeyStep.parse(XmlElement element) {
    return KeyStep(parseStep(element.innerText));
  }

  KeyStep(this.step) : super.tag(Local.keyStep, children: [XmlText(step.name)]);
}
