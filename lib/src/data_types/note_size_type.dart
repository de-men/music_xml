import 'package:xml/xml.dart';

import '../local.dart';

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

const noteSizeTypeToString = {
  NoteSizeType.cue: 'cue',
  NoteSizeType.grace: 'grace',
  NoteSizeType.graceCue: 'grace-cue',
  NoteSizeType.large: 'large',
};

class NoteSizeTypeAttr extends XmlAttribute {
  final NoteSizeType noteSizeType;

  factory NoteSizeTypeAttr.parse(String typeValue) {
    return NoteSizeTypeAttr(Local.type, parseNoteSizeType(typeValue));
  }

  NoteSizeTypeAttr(String name, this.noteSizeType)
      : super(XmlName(name), noteSizeTypeToString[noteSizeType]!);
}
