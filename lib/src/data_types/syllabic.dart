/// Where a syllable sits inside a word.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/syllabic/
enum Syllabic { single, begin, end, middle }

const syllabicMap = {
  'single': Syllabic.single,
  'begin': Syllabic.begin,
  'end': Syllabic.end,
  'middle': Syllabic.middle,
};

Syllabic parseSyllabic(String str) => syllabicMap[str] ?? Syllabic.single;

String syllabicToString(Syllabic value) => value.name;
