import 'package:xml/xml.dart';

import '../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/midi-channel/
class MidiChannel extends XmlElement {
  final int content;

  factory MidiChannel.parse(XmlElement element) {
    return MidiChannel(int.parse(element.innerText));
  }

  MidiChannel(this.content) : super(XmlName(Local.midiChannel));
}
