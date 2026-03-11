import 'package:music_xml/music_xml.dart';
import '../../../music_xml_parser_state.dart';
import 'package:xml/xml.dart';

import '../../../local.dart';
import 'duration.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/backup/
class Backup extends XmlElement {
  final Duration duration;

  factory Backup.parse(MusicXMLParserState state, XmlElement element) {
    final durationElement = element.getElement(Local.duration);
    final duration = Duration.parse(durationElement!);
    final backupDuration = duration.positiveDivisions;
    final midiTicks = backupDuration * standardPpq / state.divisions;
    final seconds = midiTicks / standardPpq * state.secondsPerQuarter;
    state.timePosition -= seconds;
    return Backup(duration);
  }

  Backup(this.duration) : super(XmlName(Local.backup), [], [duration]);
}
