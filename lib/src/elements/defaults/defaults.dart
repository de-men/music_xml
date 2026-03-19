import 'package:xml/xml.dart';

import '../../local.dart';
import 'appearance.dart';
import 'font.dart';
import 'page_layout.dart';
import 'scaling.dart';
import 'staff_layout.dart';
import 'system_layout.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/defaults/
class Defaults extends XmlElement {
  final Scaling? scaling;
  final bool concertScore;
  final PageLayout? pageLayout;
  final SystemLayout? systemLayout;
  final List<StaffLayout> staffLayouts;
  final Appearance? appearance;
  final MusicFont? musicFont;
  final WordFont? wordFont;
  final List<LyricFont> lyricFonts;
  final List<LyricLanguage> lyricLanguages;

  factory Defaults.parse(XmlElement element) {
    Scaling? scaling;
    var concertScore = false;
    PageLayout? pageLayout;
    SystemLayout? systemLayout;
    final staffLayouts = <StaffLayout>[];
    Appearance? appearance;
    MusicFont? musicFont;
    WordFont? wordFont;
    final lyricFonts = <LyricFont>[];
    final lyricLanguages = <LyricLanguage>[];

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.scaling:
          scaling = Scaling.parse(child);
          break;
        case Local.concertScore:
          concertScore = true;
          break;
        case Local.pageLayout:
          pageLayout = PageLayout.parse(child);
          break;
        case Local.systemLayout:
          systemLayout = SystemLayout.parse(child);
          break;
        case Local.staffLayout:
          staffLayouts.add(StaffLayout.parse(child));
          break;
        case Local.appearance:
          appearance = Appearance.parse(child);
          break;
        case Local.musicFont:
          musicFont = MusicFont.parse(child);
          break;
        case Local.wordFont:
          wordFont = WordFont.parse(child);
          break;
        case Local.lyricFont:
          lyricFonts.add(LyricFont.parse(child));
          break;
        case Local.lyricLanguage:
          lyricLanguages.add(LyricLanguage.parse(child));
          break;
      }
    }

    return Defaults(
      scaling: scaling,
      concertScore: concertScore,
      pageLayout: pageLayout,
      systemLayout: systemLayout,
      staffLayouts: staffLayouts,
      appearance: appearance,
      musicFont: musicFont,
      wordFont: wordFont,
      lyricFonts: lyricFonts,
      lyricLanguages: lyricLanguages,
    );
  }

  Defaults({
    this.scaling,
    this.concertScore = false,
    this.pageLayout,
    this.systemLayout,
    this.staffLayouts = const [],
    this.appearance,
    this.musicFont,
    this.wordFont,
    this.lyricFonts = const [],
    this.lyricLanguages = const [],
  }) : super.tag(
          Local.defaults,
          children: [
            if (scaling != null) scaling,
            if (pageLayout != null) pageLayout,
            if (systemLayout != null) systemLayout,
            ...staffLayouts,
            if (appearance != null) appearance,
            if (musicFont != null) musicFont,
            if (wordFont != null) wordFont,
            ...lyricFonts,
            ...lyricLanguages,
          ],
        );
}
