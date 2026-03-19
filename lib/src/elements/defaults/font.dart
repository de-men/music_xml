import 'package:xml/xml.dart';

import '../../data_types/font_size.dart';
import '../../data_types/font_style.dart';
import '../../data_types/font_weight.dart';
import '../../local.dart';

/// Shared font attributes used by music-font, word-font, and lyric-font.
class _FontAttributes {
  final String? fontFamily;
  final FontSize? fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;

  _FontAttributes({
    this.fontFamily,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
  });

  static _FontAttributes fromElement(XmlElement element) {
    final sizeStr = element.getAttribute('font-size');
    return _FontAttributes(
      fontFamily: element.getAttribute('font-family'),
      fontSize: sizeStr != null ? FontSize.parse(sizeStr) : null,
      fontStyle: parseFontStyle(element.getAttribute('font-style')),
      fontWeight: parseFontWeight(element.getAttribute('font-weight')),
    );
  }
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/music-font/
class MusicFont extends XmlElement {
  final String? fontFamily;
  final FontSize? fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;

  factory MusicFont.parse(XmlElement element) {
    final attrs = _FontAttributes.fromElement(element);
    return MusicFont(
      fontFamily: attrs.fontFamily,
      fontSize: attrs.fontSize,
      fontStyle: attrs.fontStyle,
      fontWeight: attrs.fontWeight,
    );
  }

  MusicFont({this.fontFamily, this.fontSize, this.fontStyle, this.fontWeight})
      : super.tag(Local.musicFont);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/word-font/
class WordFont extends XmlElement {
  final String? fontFamily;
  final FontSize? fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;

  factory WordFont.parse(XmlElement element) {
    final attrs = _FontAttributes.fromElement(element);
    return WordFont(
      fontFamily: attrs.fontFamily,
      fontSize: attrs.fontSize,
      fontStyle: attrs.fontStyle,
      fontWeight: attrs.fontWeight,
    );
  }

  WordFont({this.fontFamily, this.fontSize, this.fontStyle, this.fontWeight})
      : super.tag(Local.wordFont);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/lyric-font/
class LyricFont extends XmlElement {
  final String? fontFamily;
  final FontSize? fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final String? number;
  final String? lyricName;

  factory LyricFont.parse(XmlElement element) {
    final attrs = _FontAttributes.fromElement(element);
    return LyricFont(
      fontFamily: attrs.fontFamily,
      fontSize: attrs.fontSize,
      fontStyle: attrs.fontStyle,
      fontWeight: attrs.fontWeight,
      number: element.getAttribute('number'),
      lyricName: element.getAttribute('name'),
    );
  }

  LyricFont({
    this.fontFamily,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.number,
    this.lyricName,
  }) : super.tag(Local.lyricFont);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/lyric-language/
class LyricLanguage extends XmlElement {
  final String? number;
  final String? lyricName;
  final String lang;

  factory LyricLanguage.parse(XmlElement element) {
    return LyricLanguage(
      number: element.getAttribute('number'),
      lyricName: element.getAttribute('name'),
      lang: element.getAttribute('xml:lang') ?? '',
    );
  }

  LyricLanguage({this.number, this.lyricName, required this.lang})
      : super.tag(Local.lyricLanguage);
}
