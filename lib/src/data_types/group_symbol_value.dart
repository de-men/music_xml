/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/group-symbol-value/
enum GroupSymbolValue {
  brace,
  bracket,
  line,
  none,
  square,
}

const _groupSymbolValueMap = {
  'brace': GroupSymbolValue.brace,
  'bracket': GroupSymbolValue.bracket,
  'line': GroupSymbolValue.line,
  'none': GroupSymbolValue.none,
  'square': GroupSymbolValue.square,
};

GroupSymbolValue parseGroupSymbolValue(String str) =>
    _groupSymbolValueMap[str] ?? GroupSymbolValue.none;

const groupSymbolValueToString = {
  GroupSymbolValue.brace: 'brace',
  GroupSymbolValue.bracket: 'bracket',
  GroupSymbolValue.line: 'line',
  GroupSymbolValue.none: 'none',
  GroupSymbolValue.square: 'square',
};
