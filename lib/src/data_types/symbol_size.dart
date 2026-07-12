import 'package:xml/xml.dart';

import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/symbol-size/
///
/// Tells apart full, cue, grace-cue, and large symbols. Used by the `size`
/// attribute of `<type>`, `<accidental>`, `<clef>`, and `<level>`.
enum SymbolSize { cue, full, graceCue, large }

const _symbolSizeMap = {
  'cue': SymbolSize.cue,
  'full': SymbolSize.full,
  'grace-cue': SymbolSize.graceCue,
  'large': SymbolSize.large,
};

/// Returns the enum for a MusicXML value, or null when the value is not one
/// of the standard symbol sizes.
SymbolSize? parseSymbolSize(String str) => _symbolSizeMap[str];

const symbolSizeToString = {
  SymbolSize.cue: 'cue',
  SymbolSize.full: 'full',
  SymbolSize.graceCue: 'grace-cue',
  SymbolSize.large: 'large',
};

/// The `size` attribute (symbol-size) shared by several elements.
class SymbolSizeAttr extends XmlAttribute {
  final SymbolSize symbolSize;

  SymbolSizeAttr(this.symbolSize)
    : super(XmlName(Local.size), symbolSizeToString[symbolSize]!);
}
