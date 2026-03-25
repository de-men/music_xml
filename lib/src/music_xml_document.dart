import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:music_xml/src/elements/score_partwise.dart';
import 'package:xml/xml.dart';

/// Internal representation of a MusicXML Document.
///
/// Supports both uncompressed `.xml` and compressed `.mxl` input.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/score-partwise/
class MusicXmlDocument extends XmlDocument {
  final ScorePartwise score;

  /// Title of the piece
  String get title => score.movementTitle?.innerText ?? 'Unknown Piece';

  /// Total time in seconds
  double get totalTimeSecs => score.totalTimeSecs;

  /// Parse an uncompressed MusicXML string.
  factory MusicXmlDocument.parse(String input) {
    return MusicXmlDocument.fromXml(XmlDocument.parse(input));
  }

  factory MusicXmlDocument.fromXml(XmlDocument score) {
    final scorePartwiseElement = score.getElement('score-partwise')!;
    final scorePartwise = ScorePartwise.parse(scorePartwiseElement);
    return MusicXmlDocument(scorePartwise);
  }

  /// Parse a compressed `.mxl` file from raw bytes.
  ///
  /// An `.mxl` file is a ZIP archive containing one or more MusicXML files.
  /// The root file is located via `META-INF/container.xml` per the
  /// [Compressed .MXL Files](https://www.w3.org/2021/06/musicxml40/tutorial/compressed-mxl-files/)
  /// specification. If `container.xml` is absent, falls back to the first
  /// `.xml` file in the archive.
  factory MusicXmlDocument.parseMxl(List<int> bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);
    final xmlContent = _extractMusicXml(archive);
    return MusicXmlDocument.parse(xmlContent);
  }

  static String _extractMusicXml(Archive archive) {
    final container = archive.findFile('META-INF/container.xml');
    if (container != null) {
      final containerXml =
          XmlDocument.parse(utf8.decode(container.readBytes()!));
      final rootFile = containerXml
          .findAllElements('rootfile')
          .first
          .getAttribute('full-path');
      if (rootFile != null) {
        final file = archive.findFile(rootFile);
        if (file != null) {
          return utf8.decode(file.readBytes()!);
        }
      }
    }

    final xmlFile = archive.files.firstWhere(
      (f) =>
          f.name.endsWith('.xml') &&
          !f.name.startsWith('META-INF/') &&
          !f.isDirectory,
      orElse: () => throw FormatException(
        'No MusicXML file found in .mxl archive',
      ),
    );
    return utf8.decode(xmlFile.readBytes()!);
  }

  MusicXmlDocument(this.score) : super([score]);
}
