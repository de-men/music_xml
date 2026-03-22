import 'package:xml/xml.dart';

import '../../../../../local.dart';
import 'clef_octave_change.dart';
import 'line.dart';
import 'sign.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/clef/
class Clef extends XmlElement {
  // TODO: support attributes: additional, after-barline, color,
  //       default-x, default-y, font-family, font-size, font-style,
  //       font-weight, id, number, print-object, relative-x, relative-y, size
  final Sign sign;
  final Line? line;
  final ClefOctaveChange? clefOctaveChange;

  factory Clef.parse(XmlElement element) {
    late final Sign sign;
    Line? line;
    ClefOctaveChange? clefOctaveChange;

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.sign:
          sign = Sign.parse(child);
          break;
        case Local.line:
          line = Line.parse(child);
          break;
        case Local.clefOctaveChange:
          clefOctaveChange = ClefOctaveChange.parse(child);
          break;
      }
    }
    return Clef(sign, line, clefOctaveChange);
  }

  Clef(this.sign, this.line, this.clefOctaveChange)
      : super.tag(
          Local.clef,
          children: [
            sign,
            if (line != null) line,
            if (clefOctaveChange != null) clefOctaveChange,
          ],
        );
}
