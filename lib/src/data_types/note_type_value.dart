/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/note-type-value/
///
/// The graphic note type, from `1024th` (shortest) to `maxima` (longest).
/// Names that start with a digit in MusicXML get an `n` prefix here, since
/// Dart identifiers can not start with a digit.
enum NoteTypeValue {
  n1024th,
  n512th,
  n256th,
  n128th,
  n64th,
  n32nd,
  n16th,
  eighth,
  quarter,
  half,
  whole,
  breve,
  long,
  maxima,
}

const _noteTypeValueMap = {
  '1024th': NoteTypeValue.n1024th,
  '512th': NoteTypeValue.n512th,
  '256th': NoteTypeValue.n256th,
  '128th': NoteTypeValue.n128th,
  '64th': NoteTypeValue.n64th,
  '32nd': NoteTypeValue.n32nd,
  '16th': NoteTypeValue.n16th,
  'eighth': NoteTypeValue.eighth,
  'quarter': NoteTypeValue.quarter,
  'half': NoteTypeValue.half,
  'whole': NoteTypeValue.whole,
  'breve': NoteTypeValue.breve,
  'long': NoteTypeValue.long,
  'maxima': NoteTypeValue.maxima,
};

/// Returns the enum for a MusicXML value, or null when the value is not one
/// of the standard note types (some exporters write non-standard values).
NoteTypeValue? parseNoteTypeValue(String str) => _noteTypeValueMap[str];

const noteTypeValueToString = {
  NoteTypeValue.n1024th: '1024th',
  NoteTypeValue.n512th: '512th',
  NoteTypeValue.n256th: '256th',
  NoteTypeValue.n128th: '128th',
  NoteTypeValue.n64th: '64th',
  NoteTypeValue.n32nd: '32nd',
  NoteTypeValue.n16th: '16th',
  NoteTypeValue.eighth: 'eighth',
  NoteTypeValue.quarter: 'quarter',
  NoteTypeValue.half: 'half',
  NoteTypeValue.whole: 'whole',
  NoteTypeValue.breve: 'breve',
  NoteTypeValue.long: 'long',
  NoteTypeValue.maxima: 'maxima',
};
