import 'package:music_xml/music_xml.dart';
import '../../../music_xml_parser_state.dart';
import 'package:xml/xml.dart';

import '../../../local.dart';
import 'duration.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/forward/
class Forward extends XmlElement {
  final Duration duration;
  // TODO: support <footnote>, <level> (editorial-voice group), <voice>, <staff>

  factory Forward.parse(MusicXMLParserState state, XmlElement element) {
    final durationElement = element.getElement(Local.duration);
    final duration = Duration.parse(durationElement!);
    final forwardDuration = duration.positiveDivisions;
    final midiTicks = forwardDuration * standardPpq / state.divisions;
    final seconds = midiTicks / standardPpq * state.secondsPerQuarter;
    state.timePosition += seconds;
    return Forward(duration);
  }

  Forward(this.duration) : super.tag(Local.forward, children: [duration]);
}
