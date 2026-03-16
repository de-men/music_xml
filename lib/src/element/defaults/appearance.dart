import 'package:xml/xml.dart';

import '../../data_types/distance_type.dart';
import '../../data_types/glyph_type.dart';
import '../../data_types/line_width_type.dart';
import '../../data_types/note_size_type.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/line-width/
class LineWidth extends XmlElement {
  final LineWidthType type;
  final double tenths;

  factory LineWidth.parse(XmlElement element) {
    return LineWidth(
      type: parseLineWidthType(element.getAttribute('type') ?? ''),
      tenths: double.parse(element.innerText),
    );
  }

  LineWidth({required this.type, required this.tenths})
      : super.tag(Local.lineWidth);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/note-size/
class NoteSize extends XmlElement {
  final NoteSizeType type;
  final double percentage;

  factory NoteSize.parse(XmlElement element) {
    return NoteSize(
      type: parseNoteSizeType(element.getAttribute('type') ?? ''),
      percentage: double.parse(element.innerText),
    );
  }

  NoteSize({required this.type, required this.percentage})
      : super.tag(Local.noteSize);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/distance/
class Distance extends XmlElement {
  final DistanceType type;
  final double tenths;

  factory Distance.parse(XmlElement element) {
    return Distance(
      type: parseDistanceType(element.getAttribute('type') ?? ''),
      tenths: double.parse(element.innerText),
    );
  }

  Distance({required this.type, required this.tenths})
      : super.tag(Local.distance);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/glyph/
class Glyph extends XmlElement {
  final GlyphType type;
  final String smuflGlyphName;

  factory Glyph.parse(XmlElement element) {
    return Glyph(
      type: parseGlyphType(element.getAttribute('type') ?? ''),
      smuflGlyphName: element.innerText,
    );
  }

  Glyph({required this.type, required this.smuflGlyphName})
      : super.tag(Local.glyph);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/other-appearance/
class OtherAppearance extends XmlElement {
  final String type;
  final String content;

  factory OtherAppearance.parse(XmlElement element) {
    return OtherAppearance(
      type: element.getAttribute('type') ?? '',
      content: element.innerText,
    );
  }

  OtherAppearance({required this.type, required this.content})
      : super.tag(Local.otherAppearance);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/appearance/
class Appearance extends XmlElement {
  final List<LineWidth> lineWidths;
  final List<NoteSize> noteSizes;
  final List<Distance> distances;
  final List<Glyph> glyphs;
  final List<OtherAppearance> otherAppearances;

  factory Appearance.parse(XmlElement element) {
    final lineWidths = <LineWidth>[];
    final noteSizes = <NoteSize>[];
    final distances = <Distance>[];
    final glyphs = <Glyph>[];
    final otherAppearances = <OtherAppearance>[];

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.lineWidth:
          lineWidths.add(LineWidth.parse(child));
          break;
        case Local.noteSize:
          noteSizes.add(NoteSize.parse(child));
          break;
        case Local.distance:
          distances.add(Distance.parse(child));
          break;
        case Local.glyph:
          glyphs.add(Glyph.parse(child));
          break;
        case Local.otherAppearance:
          otherAppearances.add(OtherAppearance.parse(child));
          break;
      }
    }

    return Appearance(
      lineWidths: lineWidths,
      noteSizes: noteSizes,
      distances: distances,
      glyphs: glyphs,
      otherAppearances: otherAppearances,
    );
  }

  Appearance({
    this.lineWidths = const [],
    this.noteSizes = const [],
    this.distances = const [],
    this.glyphs = const [],
    this.otherAppearances = const [],
  }) : super.tag(Local.appearance);
}
