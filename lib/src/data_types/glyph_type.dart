/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/glyph-type/
enum GlyphType {
  quarterRest,
  gClefOttavaBassa,
  cClef,
  fClef,
  percussionClef,
  octaveShiftUp8,
  octaveShiftDown8,
  octaveShiftContinue8,
  octaveShiftDown15,
  octaveShiftUp15,
  octaveShiftContinue15,
  octaveShiftDown22,
  octaveShiftUp22,
  octaveShiftContinue22,
  other,
}

const _glyphTypeMap = {
  'quarter-rest': GlyphType.quarterRest,
  'g-clef-ottava-bassa': GlyphType.gClefOttavaBassa,
  'c-clef': GlyphType.cClef,
  'f-clef': GlyphType.fClef,
  'percussion-clef': GlyphType.percussionClef,
  'octave-shift-up-8': GlyphType.octaveShiftUp8,
  'octave-shift-down-8': GlyphType.octaveShiftDown8,
  'octave-shift-continue-8': GlyphType.octaveShiftContinue8,
  'octave-shift-down-15': GlyphType.octaveShiftDown15,
  'octave-shift-up-15': GlyphType.octaveShiftUp15,
  'octave-shift-continue-15': GlyphType.octaveShiftContinue15,
  'octave-shift-down-22': GlyphType.octaveShiftDown22,
  'octave-shift-up-22': GlyphType.octaveShiftUp22,
  'octave-shift-continue-22': GlyphType.octaveShiftContinue22,
};

GlyphType parseGlyphType(String str) => _glyphTypeMap[str] ?? GlyphType.other;
