/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/note-size-type/
enum NoteSizeType {
  cue,
  grace,
  graceCue,
  large,
}

const _noteSizeTypeMap = {
  'cue': NoteSizeType.cue,
  'grace': NoteSizeType.grace,
  'grace-cue': NoteSizeType.graceCue,
  'large': NoteSizeType.large,
};

NoteSizeType parseNoteSizeType(String str) => _noteSizeTypeMap[str]!;
