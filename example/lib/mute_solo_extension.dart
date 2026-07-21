import 'package:music_xml/music_xml.dart';

/// Example namespace for mixer mute and solo on `<midi-instrument>`.
///
/// Mute and solo are not standard MusicXML fields. Use a namespace your app
/// owns instead of this example URL.
const muteSoloNamespace = 'https://example.com/musicxml/mute-solo';

/// App-specific mute and solo settings stored on `<midi-instrument>`.
extension MuteSoloExtension on MidiInstrument {
  bool? get isMuted => _readYesNo('mute');

  bool? get isSolo => _readYesNo('solo');

  bool? _readYesNo(String name) {
    return switch (getAttribute(name, namespaceUri: muteSoloNamespace)) {
      'yes' => true,
      'no' => false,
      _ => null,
    };
  }
}
