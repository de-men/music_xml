import 'package:xml/xml.dart';

import '../../../../../local.dart';
import 'dynamics.dart';
import 'tempo.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/sound/
class Sound extends XmlElement {
  final Dynamics? dynamics;
  final Tempo? tempo;

  factory Sound.parse(XmlElement element) {
    Dynamics? dynamics;
    Tempo? tempo;
    for (final child in element.attributes) {
      if (child.name.local == Local.tempo) {
        tempo = Tempo.parse(child.value);
      } else if (child.name.local == Local.dynamics) {
        dynamics = Dynamics.parse(child.value);
      }
    }
    return Sound(tempo, dynamics);
  }

  Sound(this.tempo, this.dynamics)
    : super(XmlName(Local.sound), [
        if (dynamics != null) dynamics,
        if (tempo != null) tempo,
      ], []);
}
