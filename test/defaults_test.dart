import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/data_type/distance_type.dart';
import 'package:music_xml/src/data_type/glyph_type.dart';
import 'package:music_xml/src/data_type/line_width_type.dart';
import 'package:music_xml/src/data_type/margin_type.dart';
import 'package:music_xml/src/data_type/note_size_type.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/defaults-element/
final asset = File('test/assets/defaults-element.xml');

void main() {
  test('<defaults> with scaling, page-layout, system-layout, appearance', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    final defaults = document.score.defaults;
    expect(defaults, isNotNull);

    expect(defaults!.scaling!.millimeters, 7.1967);
    expect(defaults.scaling!.tenths, 40);

    expect(defaults.pageLayout!.pageHeight, 1553);
    expect(defaults.pageLayout!.pageWidth, 1200);
    expect(defaults.pageLayout!.pageMargins.length, 1);
    expect(defaults.pageLayout!.pageMargins.first.type, MarginType.both);
    expect(defaults.pageLayout!.pageMargins.first.leftMargin, 70);
    expect(defaults.pageLayout!.pageMargins.first.topMargin, 88);

    expect(defaults.systemLayout!.systemMargins!.leftMargin, 0);
    expect(defaults.systemLayout!.systemMargins!.rightMargin, 0);
    expect(defaults.systemLayout!.systemDistance, 121);
    expect(defaults.systemLayout!.topSystemDistance, 70);

    expect(defaults.appearance!.lineWidths.length, 2);
    expect(defaults.appearance!.lineWidths.first.type, LineWidthType.stem);
    expect(defaults.appearance!.lineWidths.first.tenths, 0.7487);
    expect(defaults.appearance!.noteSizes.length, 2);
    expect(defaults.appearance!.noteSizes.first.type, NoteSizeType.grace);
    expect(defaults.appearance!.noteSizes.first.percentage, 65);
    expect(defaults.appearance!.distances.length, 1);
    expect(defaults.appearance!.distances.first.type, DistanceType.hyphen);
    expect(defaults.appearance!.distances.first.tenths, 120);

    expect(defaults.musicFont!.fontFamily, 'Maestro,engraved');
    expect(defaults.musicFont!.fontSize!.isNumeric, isTrue);
    expect(defaults.musicFont!.fontSize!.numericSize, 20.4);

    expect(defaults.wordFont!.fontFamily, 'Times New Roman');
    expect(defaults.wordFont!.fontSize!.numericSize, 10.2);

    expect(defaults.lyricFonts.length, 1);
    expect(defaults.lyricFonts.first.number, '1');
    expect(defaults.lyricFonts.first.lyricName, 'verse');
    expect(defaults.lyricFonts.first.fontFamily, 'Times New Roman');
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/system-distance-element/
  test('<system-distance> element', () {
    final systemDistanceAsset = File('test/assets/system-distance-element.xml');
    final document =
        MusicXmlDocument.parse(systemDistanceAsset.readAsStringSync());

    final systemLayout = document.score.defaults!.systemLayout!;
    expect(systemLayout.systemMargins!.leftMargin, 0);
    expect(systemLayout.systemMargins!.rightMargin, 0);
    expect(systemLayout.systemDistance, 121);
    expect(systemLayout.topSystemDistance, isNull);
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/system-dividers-element/
  test('<system-dividers> element', () {
    final dividersAsset = File('test/assets/system-dividers-element.xml');
    final document = MusicXmlDocument.parse(dividersAsset.readAsStringSync());

    final systemLayout = document.score.defaults!.systemLayout!;
    expect(systemLayout.systemDistance, 96);
    expect(systemLayout.topSystemDistance, 45);

    final dividers = systemLayout.systemDividers!;
    expect(dividers.leftDivider.printObject, isTrue);
    expect(dividers.rightDivider.printObject, isTrue);
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/staff-distance-element/
  test('<staff-distance> element', () {
    final staffAsset = File('test/assets/staff-distance-element.xml');
    final document = MusicXmlDocument.parse(staffAsset.readAsStringSync());

    final staffLayouts = document.score.defaults!.staffLayouts;
    expect(staffLayouts.length, 1);
    expect(staffLayouts.first.number, 2);
    expect(staffLayouts.first.staffDistance, 65);
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/glyph-element/
  test('<glyph> element', () {
    final glyphAsset = File('test/assets/glyph-element.xml');
    final document = MusicXmlDocument.parse(glyphAsset.readAsStringSync());

    final appearance = document.score.defaults!.appearance!;
    expect(appearance.lineWidths.length, 4);
    expect(appearance.lineWidths[0].type, LineWidthType.stem);
    expect(appearance.lineWidths[1].type, LineWidthType.staff);
    expect(appearance.lineWidths[2].type, LineWidthType.lightBarline);
    expect(appearance.lineWidths[3].type, LineWidthType.leger);

    expect(appearance.glyphs.length, 2);
    expect(appearance.glyphs[0].type, GlyphType.fClef);
    expect(appearance.glyphs[0].smuflGlyphName, 'fClef19thCentury');
    expect(appearance.glyphs[1].type, GlyphType.quarterRest);
    expect(appearance.glyphs[1].smuflGlyphName, 'restQuarterOld');
  });

  test('score without <defaults> has null defaults', () {
    final noDefaults = File('test/assets/pitch-element.xml');
    final document = MusicXmlDocument.parse(noDefaults.readAsStringSync());

    expect(document.score.defaults, isNull);
  });
}
