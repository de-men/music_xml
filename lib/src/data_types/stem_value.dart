/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/stem-value/
enum StemValue {
  down,
  up,
  none,
  double,
}

const _stemValueMap = {
  'down': StemValue.down,
  'up': StemValue.up,
  'none': StemValue.none,
  'double': StemValue.double,
};

StemValue parseStemValue(String str) => _stemValueMap[str]!;

const stemValueToString = {
  StemValue.down: 'down',
  StemValue.up: 'up',
  StemValue.none: 'none',
  StemValue.double: 'double',
};
