import 'package:xml/xml.dart';

import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/line-width-type/
enum LineWidthType {
  beam,
  bracket,
  dashes,
  enclosure,
  ending,
  extend,
  heavyBarline,
  leger,
  lightBarline,
  octaveShift,
  pedal,
  slurMiddle,
  slurTip,
  staff,
  stem,
  tieMiddle,
  tieTip,
  tupletBracket,
  wedge,
  other,
}

const _lineWidthTypeMap = {
  'beam': LineWidthType.beam,
  'bracket': LineWidthType.bracket,
  'dashes': LineWidthType.dashes,
  'enclosure': LineWidthType.enclosure,
  'ending': LineWidthType.ending,
  'extend': LineWidthType.extend,
  'heavy barline': LineWidthType.heavyBarline,
  'leger': LineWidthType.leger,
  'light barline': LineWidthType.lightBarline,
  'octave shift': LineWidthType.octaveShift,
  'pedal': LineWidthType.pedal,
  'slur middle': LineWidthType.slurMiddle,
  'slur tip': LineWidthType.slurTip,
  'staff': LineWidthType.staff,
  'stem': LineWidthType.stem,
  'tie middle': LineWidthType.tieMiddle,
  'tie tip': LineWidthType.tieTip,
  'tuplet bracket': LineWidthType.tupletBracket,
  'wedge': LineWidthType.wedge,
};

LineWidthType parseLineWidthType(String str) =>
    _lineWidthTypeMap[str] ?? LineWidthType.other;

const lineWidthTypeToString = {
  LineWidthType.beam: 'beam',
  LineWidthType.bracket: 'bracket',
  LineWidthType.dashes: 'dashes',
  LineWidthType.enclosure: 'enclosure',
  LineWidthType.ending: 'ending',
  LineWidthType.extend: 'extend',
  LineWidthType.heavyBarline: 'heavy barline',
  LineWidthType.leger: 'leger',
  LineWidthType.lightBarline: 'light barline',
  LineWidthType.octaveShift: 'octave shift',
  LineWidthType.pedal: 'pedal',
  LineWidthType.slurMiddle: 'slur middle',
  LineWidthType.slurTip: 'slur tip',
  LineWidthType.staff: 'staff',
  LineWidthType.stem: 'stem',
  LineWidthType.tieMiddle: 'tie middle',
  LineWidthType.tieTip: 'tie tip',
  LineWidthType.tupletBracket: 'tuplet bracket',
  LineWidthType.wedge: 'wedge',
};

class LineWidthTypeAttr extends XmlAttribute {
  final LineWidthType lineWidthType;

  factory LineWidthTypeAttr.parse(String typeValue) {
    final parsed = parseLineWidthType(typeValue);
    return LineWidthTypeAttr(Local.type, parsed);
  }

  LineWidthTypeAttr(String name, this.lineWidthType)
      : super(XmlName(name),
            lineWidthTypeToString[lineWidthType] ?? lineWidthType.name);
}
