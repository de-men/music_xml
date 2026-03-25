## 2.7.0

* Support [compressed `.mxl` files](https://www.w3.org/2021/06/musicxml40/tutorial/compressed-mxl-files/) via `MusicXmlDocument.parseMxl(List<int> bytes)` [#37](https://github.com/de-men/music_xml/issues/37)
* Locates root file via `META-INF/container.xml`; falls back to first `.xml` in the archive

## 2.6.0

### New Features

* [`<notations>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/notations/) element with `<tied>`, `<slur>`, `<tuplet>`, `<fermata>`, `<articulations>`, `<ornaments>`, `<dynamics>`, `<technical>`, `<accidental-mark>`
* Direct `<note>` children: [`<beam>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/beam/), [`<stem>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/stem/), [`<staff>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/staff/), [`<accidental>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/accidental/), [`<rest>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/rest/), [`<dot>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/dot/), [`<voice>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/voice/), [`<duration>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/duration/)
* [`<tie>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/tie/) refactored to `XmlElement` with `StartStopAttr` and `time-only` attribute
* Data type enums: `BeamValue`, `StemValue`, `StartStopContinue`, `TiedType`, `FermataShape`, `UprightInverted`
* Shared element: [`<voice>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/voice/) (multi-parent: `<note>`, `<direction>`, `<forward>`)
* Moved `lyric.dart`, `tie.dart`, `grace.dart` into `note/` directory

### Breaking Changes

* `Note.voice` changed from `int` to `Voice?` (use `.content` for the string value)
* `Note.isRest` is now a getter (`rest != null`); `Note.rest` is a typed `Rest?` element
* `Tie.type` changed from `StartStop` to `StartStopAttr` (use `.startStop` for the enum value)

## 2.5.0

* [`<part-group>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/part-group/) element with `group-name`, `group-name-display`, `group-abbreviation`, `group-abbreviation-display`, `group-symbol`, `group-barline`, `group-time`, `footnote`, `level`
* `PartList` preserves interleaved order of `<part-group>` and `<score-part>` elements via `items`
* Data type enums: `GroupSymbolValue`, `GroupBarlineValue`
* Shared elements: [`<display-text>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/display-text/), [`<accidental-text>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/accidental-text/), [`<footnote>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/footnote/), [`<level>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/level/)
* Moved `StartStop` to `data_types/` with `StartStopAttr` class

## 2.4.1

* Complete element roundtripping audit — every `XmlElement` subclass now passes proper `attributes:` and `children:` to `super.tag()`
* Typed attribute classes: `DecimalAttr`, `IntAttr`, `YesNoAttr`, `ValignAttr`, `EnclosureShapeAttr`, `TextDirectionAttr`, `XmlSpaceAttr`
* Element fields store typed `XmlAttribute` objects directly for zero-conversion roundtripping
* Parse methods use single-pass `for`/`switch` over attributes for O(n) instead of repeated `getAttribute` calls
* Proper element classes for layout children: `LeftMargin`, `RightMargin`, `TopMargin`, `BottomMargin`, `PageHeight`, `PageWidth`, `StaffDistance`, `SystemDistance`, `TopSystemDistance`
* Moved data types to `data_types/`: `AccidentalValue`, `ClefSign`
* Fixed `Supports.parse` to read XML attributes instead of child elements
* Added `Local` constants for common attribute names
* Upgraded `xml` to 6.6.1, `test` to 1.31.0

## 2.4.0

* [`<credit>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/credit/) element with `credit-type`, `credit-words`, `credit-symbol`, `credit-image`, `link`, `bookmark`
* Sealed `CreditContent` class with `Credit.image` / `Credit.content` constructors
* Data type enums: `CreditTypeValue`, `XLinkActuate`, `XLinkShow`, `XLinkType`, `LeftCenterRight`, `Valign`, `ValignImage`, `TextDirection`, `EnclosureShape`, `XmlSpace`
* Bump SDK to `>=3.2.0` for sealed classes

## 2.3.0

* [`<defaults>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/defaults/) element with `scaling`, `concert-score`, `page-layout`, `system-layout`, `staff-layout`, `appearance`, `system-dividers`, `music-font`, `word-font`, `lyric-font`, `lyric-language`
* Data type enums: `MarginType`, `LineWidthType`, `NoteSizeType`, `DistanceType`, `GlyphType`, `FontStyle`, `FontWeight`, `FontSize`

## 2.2.0

* [`<identification>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/identification/) element with `creator`, `rights`, `encoding`, `source`, `relation`, `miscellaneous`, and [`<supports>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/supports/)

## 2.1.0

* [`<work>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/work/) element with `work-number`, `work-title`, and [`<opus>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/opus-reference/) (XLink) [#42](https://github.com/de-men/music_xml/pull/42)

## 2.0.0

### New Features

* Restructured codebase to mirror the [MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/) element hierarchy
* All elements now extend `XmlElement`, enabling XML roundtripping (parse and serialize)
* [`<unpitched>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/unpitched/) support for percussion scores
* [`<grace>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/grace/) with typed attributes (`slash`, `steal-time-following`, `steal-time-previous`, `make-time`)
* [`<chord>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/chord/) as a typed element
* [`<score-partwise>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/score-partwise/) with `version`, `movement-number`, `movement-title`
* [`<part-list>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/part-list/) / [`<midi-instrument>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/midi-instrument/) as typed elements
* Typed [`<attributes>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/attributes/) with `divisions`, `key`, `time`, `clef`, `transpose` as child elements
* [`<key>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/key/) with `key-step`, `key-alter`, [`<key-accidental>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/key-accidental/) (full `AccidentalValue` enum)
* [`<clef>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/clef/) with typed [`ClefSign`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/clef-sign/) enum
* [`<backup>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/backup/) / [`<forward>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/forward/) / [`<direction>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/direction/) / [`<sound>`](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/sound/) as typed elements
* `Pitch.toMidiPitch()` and `Pitch.toPitchString()` methods

### Breaking Changes

* **`MusicXmlDocument`**
  * `document.scoreParts` -> `document.score.partList.scoreParts`
  * `document.parts` -> `document.score.parts`
* **`Measure`**
  * `measure.clefSignature` -> `measure.attributesList.first.clefs`
  * `measure.timeSignature` -> `measure.attributesList.first.times`
  * `measure.keySignature` -> `measure.attributesList.first.keys`
  * `measure.barline` (single) -> `measure.barlines` (list)
  * `measure.number` changed from `int` to `Number` (use `.value`)
* **`Note`**
  * `note.pitch` (was `MapEntry<String, int>`) renamed to `note.pitchMap`
  * `note.pitchTypeSafe` renamed to `note.pitch` (now the typed `Pitch` object)
* **Renamed classes**
  * `KeySignature` -> `Key` (mode is now a `Mode` object instead of `String`)
  * `ClefSignature` -> `Clef` (sign is now a `Sign` object with `ClefSign` enum)
  * `TimeSignature` -> `Time`
* **`ScorePart`**
  * `ScorePart.id` changed from `String` to `Id` (use `.value`)
  * `ScorePart.partName` changed from `String` to `PartName` (use `.content`)
* **`Tempo`**
  * `timePosition` removed (accessible via `Sound` parent)
* **`MusicXMLParserState`** removed from public exports (internal implementation detail)

### Bug Fixes

* Fix `Attributes.parse` times parameter shadowing preventing time signatures from flowing to `_fixTimeSignature`
* Fix `KeyAccidental.parse` crash on unrecognized accidental values (now falls back to `AccidentalValue.other`)
* Fix `Grace.parse` parsing `makeTime` attribute twice
* Fix `Tempo.qpm` getter returning `dynamic` instead of `double`
* Fix `_repairEmptyMeasure` being a no-op (body was commented out)
* Fix floating-point comparison in `_fixTimeSignature` (now uses integer cross-multiplication)
* Fix `Transpose.parse` being called twice in `Attributes.parse`
* Remove duplicate pitch parsing in `Note` (consolidated into `Pitch` object)
* Standardize factory constructors to `.parse()` (was inconsistent `.parse()` / `.fromXml()`)
* Rename `chore.dart` to `chord.dart` (typo)

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
