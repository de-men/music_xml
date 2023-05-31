import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';

/// Internal representation of a MusicXML <score-part>.
///
/// A <score-part> element contains MIDI program and channel info
/// for the <part> elements in the MusicXML document.
///
/// If no MIDI info is found for the part, use the default MIDI channel (0)
/// and default to the Grand Piano program (MIDI Program #1).
class ScorePart {
  final String id;
  final String name;
  final int midiChannel;
  final int midiProgram;

  /// Parse the <score-part> element to an in-memory representation.
  factory ScorePart.parse(XmlElement element) {
    final midiInstrument = element.getElement('midi-instrument');
    int? midiChannel;
    int? midiProgram;
    if (midiInstrument != null) {
      final midiChannelElement = midiInstrument.getElement('midi-channel');
      final midiProgramElement = midiInstrument.getElement('midi-program');
      midiChannel = int.tryParse(midiChannelElement?.innerText ?? '');
      midiProgram = int.tryParse(midiProgramElement?.innerText ?? '');
    }
    return ScorePart(
      element.getAttribute('id') ?? '',
      element.getElement('part-name')?.innerText ?? '',
      midiChannel ?? defaultMidiChannel,
      midiProgram ?? defaultMidiProgram,
    );
  }

  ScorePart([
    this.id = '',
    this.name = '',
    // If no MIDI info, use the default MIDI channel.
    this.midiChannel = defaultMidiChannel,
    // Use the default MIDI program
    this.midiProgram = defaultMidiProgram,
  ]);

  @override
  String toString() =>
      'ScorePart: $name, Channel: $midiChannel, Program: $midiProgram';
}
