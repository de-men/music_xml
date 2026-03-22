import 'package:xml/xml.dart';

import '../../attributes/token_attribute.dart';
import '../../data_types/font_size.dart';
import '../../data_types/font_style.dart';
import '../../data_types/font_weight.dart';
import '../../local.dart';

/// Parses shared font attributes from an element.
class _FontAttrs {
  final TokenAttr? fontFamily;
  final FontSizeAttr? fontSize;
  final FontStyleAttr? fontStyle;
  final FontWeightAttr? fontWeight;

  _FontAttrs({this.fontFamily, this.fontSize, this.fontStyle, this.fontWeight});

  static _FontAttrs fromElement(XmlElement element) {
    TokenAttr? fontFamily;
    FontSizeAttr? fontSize;
    FontStyleAttr? fontStyle;
    FontWeightAttr? fontWeight;

    for (final attr in element.attributes) {
      final name = attr.name.local;
      final v = attr.value;
      switch (name) {
        case Local.fontFamily:
          fontFamily = TokenAttr(name, v);
          break;
        case Local.fontSize:
          fontSize = FontSizeAttr(name, FontSize.parse(v));
          break;
        case Local.fontStyle:
          final parsed = parseFontStyle(v);
          if (parsed != null) fontStyle = FontStyleAttr(name, parsed);
          break;
        case Local.fontWeight:
          final parsed = parseFontWeight(v);
          if (parsed != null) fontWeight = FontWeightAttr(name, parsed);
          break;
      }
    }

    return _FontAttrs(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
    );
  }
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/music-font/
class MusicFont extends XmlElement {
  final TokenAttr? fontFamily;
  final FontSizeAttr? fontSize;
  final FontStyleAttr? fontStyle;
  final FontWeightAttr? fontWeight;

  factory MusicFont.parse(XmlElement element) {
    final attrs = _FontAttrs.fromElement(element);
    return MusicFont(
      fontFamily: attrs.fontFamily,
      fontSize: attrs.fontSize,
      fontStyle: attrs.fontStyle,
      fontWeight: attrs.fontWeight,
    );
  }

  MusicFont({this.fontFamily, this.fontSize, this.fontStyle, this.fontWeight})
      : super.tag(
          Local.musicFont,
          attributes: [
            if (fontFamily != null) fontFamily,
            if (fontSize != null) fontSize,
            if (fontStyle != null) fontStyle,
            if (fontWeight != null) fontWeight,
          ],
        );
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/word-font/
class WordFont extends XmlElement {
  final TokenAttr? fontFamily;
  final FontSizeAttr? fontSize;
  final FontStyleAttr? fontStyle;
  final FontWeightAttr? fontWeight;

  factory WordFont.parse(XmlElement element) {
    final attrs = _FontAttrs.fromElement(element);
    return WordFont(
      fontFamily: attrs.fontFamily,
      fontSize: attrs.fontSize,
      fontStyle: attrs.fontStyle,
      fontWeight: attrs.fontWeight,
    );
  }

  WordFont({this.fontFamily, this.fontSize, this.fontStyle, this.fontWeight})
      : super.tag(
          Local.wordFont,
          attributes: [
            if (fontFamily != null) fontFamily,
            if (fontSize != null) fontSize,
            if (fontStyle != null) fontStyle,
            if (fontWeight != null) fontWeight,
          ],
        );
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/lyric-font/
class LyricFont extends XmlElement {
  final TokenAttr? fontFamily;
  final FontSizeAttr? fontSize;
  final FontStyleAttr? fontStyle;
  final FontWeightAttr? fontWeight;
  final TokenAttr? number;
  final TokenAttr? lyricName;

  factory LyricFont.parse(XmlElement element) {
    final attrs = _FontAttrs.fromElement(element);
    TokenAttr? number;
    TokenAttr? lyricName;

    for (final attr in element.attributes) {
      final name = attr.name.local;
      final v = attr.value;
      switch (name) {
        case Local.number:
          number = TokenAttr(name, v);
          break;
        case Local.name:
          lyricName = TokenAttr(name, v);
          break;
      }
    }

    return LyricFont(
      fontFamily: attrs.fontFamily,
      fontSize: attrs.fontSize,
      fontStyle: attrs.fontStyle,
      fontWeight: attrs.fontWeight,
      number: number,
      lyricName: lyricName,
    );
  }

  LyricFont({
    this.fontFamily,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.number,
    this.lyricName,
  }) : super.tag(
          Local.lyricFont,
          attributes: [
            if (number != null) number,
            if (lyricName != null) lyricName,
            if (fontFamily != null) fontFamily,
            if (fontSize != null) fontSize,
            if (fontStyle != null) fontStyle,
            if (fontWeight != null) fontWeight,
          ],
        );
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/lyric-language/
class LyricLanguage extends XmlElement {
  final TokenAttr? number;
  final TokenAttr? lyricName;
  final TokenAttr lang;

  factory LyricLanguage.parse(XmlElement element) {
    TokenAttr? number;
    TokenAttr? lyricName;
    late TokenAttr lang;

    for (final attr in element.attributes) {
      final name = attr.name.qualified;
      final v = attr.value;
      switch (name) {
        case Local.number:
          number = TokenAttr(name, v);
          break;
        case Local.name:
          lyricName = TokenAttr(name, v);
          break;
        case Local.xmlLang:
          lang = TokenAttr(name, v);
          break;
      }
    }

    return LyricLanguage(number: number, lyricName: lyricName, lang: lang);
  }

  LyricLanguage({this.number, this.lyricName, required this.lang})
      : super.tag(
          Local.lyricLanguage,
          attributes: [
            if (number != null) number,
            if (lyricName != null) lyricName,
            lang,
          ],
        );
}
