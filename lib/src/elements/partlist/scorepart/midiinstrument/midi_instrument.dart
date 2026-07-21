import 'package:xml/xml.dart';

import '../../../../local.dart';
import '../../../../attributes/id.dart';
import 'midi_channel.dart';
import 'midi_program.dart';
import 'pan.dart';
import 'volume.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/midi-instrument/
class MidiInstrument extends XmlElement {
  final Id id;
  final MidiChannel? midiChannel;
  // TODO: support <midi-name>, <midi-bank>
  final MidiProgram? midiProgram;
  // TODO: support <midi-unpitched>, <elevation>
  final Volume? volume;
  final Pan? pan;

  /// Non-standard attributes kept for app-specific MusicXML extensions.
  ///
  /// Use a namespace for custom attributes to avoid conflicts with MusicXML.
  final List<XmlAttribute> extensionAttributes;

  factory MidiInstrument.parse(XmlElement element) {
    final idAttribute = element.getAttribute(Local.id)!;

    MidiChannel? midiChannel;
    MidiProgram? midiProgram;
    Volume? volume;
    Pan? pan;
    element.childElements.forEach((e) {
      switch (e.name.local) {
        case Local.midiChannel:
          midiChannel = MidiChannel.parse(e);
          break;
        case Local.midiProgram:
          midiProgram = MidiProgram.parse(e);
          break;
        case Local.volume:
          volume = Volume.parse(e);
          break;
        case Local.pan:
          pan = Pan.parse(e);
          break;
      }
    });

    return MidiInstrument(
      Id(idAttribute),
      midiChannel: midiChannel,
      midiProgram: midiProgram,
      volume: volume,
      pan: pan,
      extensionAttributes: element.attributes
          .where((attribute) => attribute.name.qualified != Local.id)
          .map((attribute) => attribute.copy())
          .toList(),
    );
  }

  MidiInstrument(
    this.id, {
    this.midiChannel,
    this.midiProgram,
    this.volume,
    this.pan,
    this.extensionAttributes = const [],
  }) : super.tag(
         Local.midiInstrument,
         attributes: [id, ...extensionAttributes],
         children: [
           if (midiChannel != null) midiChannel,
           if (midiProgram != null) midiProgram,
           if (volume != null) volume,
           if (pan != null) pan,
         ],
       );
}
