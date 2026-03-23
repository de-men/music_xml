import 'package:xml/xml.dart';

import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/start-stop/
enum StartStop { start, stop }

const _startStopMap = {
  'start': StartStop.start,
  'stop': StartStop.stop,
};

StartStop parseStartStop(String str) => _startStopMap[str]!;

const startStopToString = {
  StartStop.start: 'start',
  StartStop.stop: 'stop',
};

class StartStopAttr extends XmlAttribute {
  final StartStop startStop;

  factory StartStopAttr.parse(String typeValue) {
    return StartStopAttr(Local.type, parseStartStop(typeValue));
  }

  StartStopAttr(String name, this.startStop)
      : super(XmlName(name), startStopToString[startStop]!);
}
