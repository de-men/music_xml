import 'package:music_xml/music_xml.dart';
import 'package:xml/xml.dart';

import '../../../../local.dart';
import 'sound/sound.dart';

class Direction extends XmlElement {
  final Sound? sound;

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
    : super(XmlName(Local.direction), [], [if (sound != null) sound]);
}
