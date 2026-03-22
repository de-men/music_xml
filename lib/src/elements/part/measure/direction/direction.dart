import '../../../../music_xml_parser_state.dart';
import 'package:xml/xml.dart';

import '../../../../local.dart';
import 'sound/sound.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/direction/
class Direction extends XmlElement {
  // TODO: support <direction-type> (One or more times, required)
  // TODO: support <offset> (Optional)
  // TODO: support <footnote>, <level> (editorial group, Optional)
  // TODO: support <voice> (Optional)
  // TODO: support <staff> (Optional)
  final Sound? sound;
  // TODO: support <listening> (Optional)

  factory Direction.parse(MusicXMLParserState state, XmlElement element) {
    Sound? sound;
    for (final child in element.childElements) {
      if (child.name.local == Local.sound) {
        sound = Sound.parse(child);
      }
    }
    return Direction(sound);
  }

  Direction(this.sound)
      : super.tag(
          Local.direction,
          children: [if (sound != null) sound],
        );
}
