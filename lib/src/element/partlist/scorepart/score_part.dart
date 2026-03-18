import 'package:music_xml/src/element/id.dart';
import 'package:music_xml/src/element/partlist/scorepart/midiinstrument/midi_instrument.dart';
import 'package:music_xml/src/element/partlist/scorepart/part_name.dart';
import 'package:xml/xml.dart';

import '../../../local.dart';
import '../../../music_xml_parser_state.dart';

/// Internal representation of a MusicXML `<score-part>`.
///
/// A `<score-part>` element contains MIDI program and channel info
/// for the `<part>` elements in the MusicXML document.
///
/// If no MIDI info is found for the part, use the default MIDI channel (0)
/// and default to the Grand Piano program (MIDI Program #1).
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/score-part/
class ScorePart extends XmlElement {
  // Attributes
  final Id id;

  // Elements
  final PartName partName;

  // Zero or more times
  final Iterable<MidiInstrument> midiInstruments;

  // Extension
  final int midiChannel;
  final int midiProgram;

  /// Parse the `<score-part>` element to an in-memory representation.
  factory ScorePart.parse(XmlElement element) {
    final idAttribute = element.getAttribute(Local.id)!;

    late final PartName partName;
    final midiInstruments = <MidiInstrument>[];
    int? midiChannel = null;
    int? midiProgram = null;
    element.childElements.forEach((e) {
      switch (e.name.local) {
        case Local.partName:
          partName = PartName.parse(e);
          break;
        case Local.midiInstrument:
          final midiInstrument = MidiInstrument.parse(e);
          midiInstruments.add(midiInstrument);
          midiChannel ??= midiInstrument.midiChannel?.content;
          midiProgram ??= midiInstrument.midiProgram?.content;
          break;
      }
    });

    return ScorePart(
      id: Id(idAttribute),
      partName: partName,
      midiInstruments: midiInstruments,
      midiChannel: midiChannel ?? defaultMidiChannel,
      midiProgram: midiProgram ?? defaultMidiProgram,
    );
  }

  ScorePart({
    required this.id,
    required this.partName,
    this.midiInstruments = const [],
    this.midiChannel = defaultMidiChannel,
    this.midiProgram = defaultMidiProgram,
  }) : super.tag(
          Local.scorePart,
          attributes: [id],
          children: [partName, ...midiInstruments],
        );
}
