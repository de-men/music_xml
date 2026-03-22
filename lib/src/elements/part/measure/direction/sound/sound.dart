import 'package:xml/xml.dart';

import '../../../../../local.dart';
import '../../../../../attributes/dynamics.dart';
import '../../../../../attributes/tempo.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/sound/
class Sound extends XmlElement {
  // TODO: support attributes: coda, dacapo, dalsegno, damper-pedal,
  //       divisions, elevation, fine, forward-repeat, id, pan,
  //       pizzicato, segno, soft-pedal, sostenuto-pedal, time-only, tocoda
  final Dynamics? dynamics;
  final Tempo? tempo;
  // TODO: support children: <instrument-change>, <midi-device>,
  //       <midi-instrument>, <play>, <swing>, <offset>

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
      : super.tag(
          Local.sound,
          attributes: [
            if (dynamics != null) dynamics,
            if (tempo != null) tempo,
          ],
        );
}
