# music_xml

![Build](https://github.com/de-men/music_xml/workflows/ci/badge.svg)
[![pub package](https://img.shields.io/pub/v/music_xml.svg)](https://pub.dev/packages/music_xml)

A Dart package to parse and serialize [MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/).

## Features

- Parse MusicXML documents into typed Dart objects
- Support for both uncompressed `.xml` and [compressed `.mxl`](https://www.w3.org/2021/06/musicxml40/tutorial/compressed-mxl-files/) files
- All elements extend `XmlElement` for XML roundtripping (parse and serialize)
- Supports: notes, pitches, unpitched (percussion), grace notes, chords, lyrics, ties, key/time/clef signatures, tempo, dynamics, chord symbols, barlines, and more
- Follows the [MusicXML 4.0 element hierarchy](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/score-partwise/)

## Getting started

Add `music_xml` to your `pubspec.yaml`:

```yaml
dependencies:
  music_xml: ^2.0.0
```

## Usage

```dart
import 'package:music_xml/music_xml.dart';

// Parse uncompressed XML string
final document = MusicXmlDocument.parse(xmlString);

// Parse compressed .mxl file bytes
final mxlDocument = MusicXmlDocument.parseMxl(mxlBytes);

// Access score structure
final parts = document.score.parts;
final measures = parts.first.measures;
final notes = measures.first.notes;

// Access typed elements
final pitch = notes.first.pitch;
print(pitch?.toPitchString()); // "C4"
print(pitch?.toMidiPitch());   // 60
```

## Deployment

Run the publish command in dry-run mode to see if everything passes analysis:

```shell
flutter pub publish --dry-run
```

Publish to pub.dev:

```shell
flutter pub publish
```

## Additional information

Originally inspired by Google's Magenta [musicxml_parser.py](https://github.com/magenta/note-seq/blob/main/note_seq/musicxml_parser.py), now restructured as a standalone MusicXML 4.0 library.
