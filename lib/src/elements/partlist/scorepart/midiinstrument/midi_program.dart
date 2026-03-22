import 'package:xml/xml.dart';

import '../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/midi-program/
class MidiProgram extends XmlElement {
  final int content;

  factory MidiProgram.parse(XmlElement element) {
    return MidiProgram(int.parse(element.innerText));
  }

  MidiProgram(this.content)
      : super.tag(Local.midiProgram, children: [XmlText('$content')]);
}
