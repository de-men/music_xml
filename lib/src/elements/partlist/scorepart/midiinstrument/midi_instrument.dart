import 'package:xml/xml.dart';

import '../../../../local.dart';
import '../../../../attributes/id.dart';
import 'midi_channel.dart';
import 'midi_program.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/midi-instrument/
class MidiInstrument extends XmlElement {
  final Id id;
  final MidiChannel? midiChannel;
  // TODO: support <midi-name>, <midi-bank>
  final MidiProgram? midiProgram;
  // TODO: support <midi-unpitched>, <volume>, <pan>, <elevation>

  factory MidiInstrument.parse(XmlElement element) {
    final idAttribute = element.getAttribute(Local.id)!;

    MidiChannel? midiChannel;
    MidiProgram? midiProgram;
    element.childElements.forEach((e) {
      switch (e.name.local) {
        case Local.midiChannel:
          midiChannel = MidiChannel.parse(e);
          break;
        case Local.midiProgram:
          midiProgram = MidiProgram.parse(e);
          break;
      }
    });

    return MidiInstrument(
      Id(idAttribute),
      midiChannel: midiChannel,
      midiProgram: midiProgram,
    );
  }

  MidiInstrument(this.id, {this.midiChannel, this.midiProgram})
      : super.tag(
          Local.midiInstrument,
          attributes: [id],
          children: [
            if (midiChannel != null) midiChannel,
            if (midiProgram != null) midiProgram,
          ],
        );
}
