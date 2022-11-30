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
