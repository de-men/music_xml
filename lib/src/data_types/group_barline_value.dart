/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/group-barline-value/
enum GroupBarlineValue {
  yes,
  no,
  mensurstrich,
}

const _groupBarlineValueMap = {
  'yes': GroupBarlineValue.yes,
  'no': GroupBarlineValue.no,
  'Mensurstrich': GroupBarlineValue.mensurstrich,
};

GroupBarlineValue parseGroupBarlineValue(String str) =>
    _groupBarlineValueMap[str] ?? GroupBarlineValue.no;

const groupBarlineValueToString = {
  GroupBarlineValue.yes: 'yes',
  GroupBarlineValue.no: 'no',
  GroupBarlineValue.mensurstrich: 'Mensurstrich',
};
