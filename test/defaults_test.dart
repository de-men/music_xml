import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/data_types/margin_type.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/defaults-element/
final asset = File('test/assets/defaults-element.xml');

void main() {
  test('<defaults> with scaling, page-layout, system-layout, appearance', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    final defaults = document.score.defaults;
    expect(defaults, isNotNull);

    expect(defaults!.scaling!.millimeters.millimeters, 7.1967);
    expect(defaults.scaling!.tenths.tenths, 40);

    expect(defaults.pageLayout!.pageHeight!.tenths, 1553);
    expect(defaults.pageLayout!.pageWidth!.tenths, 1200);
    expect(defaults.pageLayout!.pageMargins.length, 1);
    expect(defaults.pageLayout!.pageMargins.first.type?.marginType,
        MarginType.both);
    expect(defaults.pageLayout!.pageMargins.first.leftMargin.tenths, 70);
    expect(defaults.pageLayout!.pageMargins.first.topMargin.tenths, 88);

    expect(defaults.systemLayout!.systemMargins!.leftMargin.tenths, 0);
    expect(defaults.systemLayout!.systemMargins!.rightMargin.tenths, 0);
    expect(defaults.systemLayout!.systemDistance!.tenths, 121);
    expect(defaults.systemLayout!.topSystemDistance!.tenths, 70);

    expect(defaults.appearance!.lineWidths.length, 2);
    expect(defaults.appearance!.lineWidths.first.type.value, 'stem');
    expect(defaults.appearance!.lineWidths.first.tenths, 0.7487);
    expect(defaults.appearance!.noteSizes.length, 2);
    expect(defaults.appearance!.noteSizes.first.type.value, 'grace');
    expect(defaults.appearance!.distances.length, 1);
    expect(defaults.appearance!.distances.first.type.value, 'hyphen');

    expect(defaults.musicFont!.fontFamily?.value, 'Maestro,engraved');
    expect(defaults.musicFont!.fontSize?.fontSize.isNumeric, isTrue);
    expect(defaults.musicFont!.fontSize?.fontSize.numericSize, 20.4);

    expect(defaults.wordFont!.fontFamily?.value, 'Times New Roman');
    expect(defaults.wordFont!.fontSize?.fontSize.numericSize, 10.2);

    expect(defaults.lyricFonts.length, 1);
    expect(defaults.lyricFonts.first.number?.value, '1');
    expect(defaults.lyricFonts.first.lyricName?.value, 'verse');
    expect(defaults.lyricFonts.first.fontFamily?.value, 'Times New Roman');
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/system-distance-element/
  test('<system-distance> element', () {
    final systemDistanceAsset = File('test/assets/system-distance-element.xml');
    final document =
        MusicXmlDocument.parse(systemDistanceAsset.readAsStringSync());

    final systemLayout = document.score.defaults!.systemLayout!;
    expect(systemLayout.systemMargins!.leftMargin.tenths, 0);
    expect(systemLayout.systemMargins!.rightMargin.tenths, 0);
    expect(systemLayout.systemDistance!.tenths, 121);
    expect(systemLayout.topSystemDistance, isNull);
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/system-dividers-element/
  test('<system-dividers> element', () {
    final dividersAsset = File('test/assets/system-dividers-element.xml');
    final document = MusicXmlDocument.parse(dividersAsset.readAsStringSync());

    final systemLayout = document.score.defaults!.systemLayout!;
    expect(systemLayout.systemDistance!.tenths, 96);
    expect(systemLayout.topSystemDistance!.tenths, 45);

    final dividers = systemLayout.systemDividers!;
    expect(dividers.leftDivider.printObject.value, 'yes');
    expect(dividers.rightDivider.printObject.value, 'yes');
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/staff-distance-element/
  test('<staff-distance> element', () {
    final staffAsset = File('test/assets/staff-distance-element.xml');
    final document = MusicXmlDocument.parse(staffAsset.readAsStringSync());

    final staffLayouts = document.score.defaults!.staffLayouts;
    expect(staffLayouts.length, 1);
    expect(staffLayouts.first.number?.intValue, 2);
    expect(staffLayouts.first.staffDistance?.tenths, 65);
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/glyph-element/
  test('<glyph> element', () {
    final glyphAsset = File('test/assets/glyph-element.xml');
    final document = MusicXmlDocument.parse(glyphAsset.readAsStringSync());

    final appearance = document.score.defaults!.appearance!;
    expect(appearance.lineWidths.length, 4);
    expect(appearance.lineWidths[0].type.value, 'stem');
    expect(appearance.lineWidths[1].type.value, 'staff');
    expect(appearance.lineWidths[2].type.value, 'light barline');
    expect(appearance.lineWidths[3].type.value, 'leger');

    expect(appearance.glyphs.length, 2);
    expect(appearance.glyphs[0].type.value, 'f-clef');
    expect(appearance.glyphs[0].smuflGlyphName, 'fClef19thCentury');
    expect(appearance.glyphs[1].type.value, 'quarter-rest');
    expect(appearance.glyphs[1].smuflGlyphName, 'restQuarterOld');
  });

  test('score without <defaults> has null defaults', () {
    final noDefaults = File('test/assets/pitch-element.xml');
    final document = MusicXmlDocument.parse(noDefaults.readAsStringSync());

    expect(document.score.defaults, isNull);
  });
}
