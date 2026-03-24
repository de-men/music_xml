/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/tied-type/
enum TiedType {
  start,
  stop,
  continueValue,
  letRing,
}

const _tiedTypeMap = {
  'start': TiedType.start,
  'stop': TiedType.stop,
  'continue': TiedType.continueValue,
  'let-ring': TiedType.letRing,
};

TiedType parseTiedType(String str) => _tiedTypeMap[str]!;

const tiedTypeToString = {
  TiedType.start: 'start',
  TiedType.stop: 'stop',
  TiedType.continueValue: 'continue',
  TiedType.letRing: 'let-ring',
};
