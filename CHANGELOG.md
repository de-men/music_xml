## 1.3.0

* Read [`<clef>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/clef/) element

## 1.2.2

* fix: Xml documents with multiple score parts were not read anymore [#13](https://github.com/de-men/music_xml/pull/13)

## 1.2.1

* fix: doubled ties [#9](https://github.com/de-men/music_xml/pull/9)
* fix: parse part-name [#9](https://github.com/de-men/music_xml/pull/9)
* fix: parse list part [#10](https://github.com/de-men/music_xml/pull/10)

## 1.2.0

* Don't throw an exception when the lyric has no text
* Read `movement-title`
* Identify notes belonging to the same tied note by a shared id
* Refactor ChordSymbol to prevent warnings
* Add `SimpleKind` to get the basic form of a chord, i.e. `major`, `minor`, `augmented`, `diminished`, `sus` or `other`. With `.kind.simple`, the simple kind can be read out.
* Add `Note.pitchTypeSafe` property to read out pitch information more easily.
* Add `Note.noteDurationTied` to get the complied duration of a tied note.
* Add additional note information `Note.isNoteOn`, `isNoteOff`, `continuesOtherNote`, `isContinuedByOtherNote`

## 1.1.0

* Add lyric, tie, print ([#3](https://github.com/de-men/music_xml/pull/3))

## 1.0.4

* Public constructor

## 1.0.3

* Upgrade dependencies

## 1.0.2

* Refactor constructors with factory

## 1.0.1

* Remove redundant dependencies

## 1.0.0

* Support parse from xml string.
