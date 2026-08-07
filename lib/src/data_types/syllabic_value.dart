/// Where a syllable sits inside a word.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/syllabic/
enum SyllabicValue { single, begin, end, middle }

const syllabicValueMap = {
  'single': SyllabicValue.single,
  'begin': SyllabicValue.begin,
  'end': SyllabicValue.end,
  'middle': SyllabicValue.middle,
};

SyllabicValue parseSyllabicValue(String str) =>
    syllabicValueMap[str] ?? SyllabicValue.single;

String syllabicValueToString(SyllabicValue value) => value.name;
