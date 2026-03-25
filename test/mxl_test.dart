import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

final xmlFile = File('test/assets/musicXML.xml');

Archive _createMxlArchive(String xmlContent, {bool includeContainer = true}) {
  final archive = Archive();

  if (includeContainer) {
    final container = '''<?xml version="1.0" encoding="UTF-8"?>
<container>
  <rootfiles>
    <rootfile full-path="score.xml"/>
  </rootfiles>
</container>''';
    archive.addFile(
      ArchiveFile.bytes('META-INF/container.xml', utf8.encode(container)),
    );
  }

  archive.addFile(ArchiveFile.bytes('score.xml', utf8.encode(xmlContent)));
  return archive;
}

void main() {
  final xmlContent = xmlFile.readAsStringSync();
  final xmlDocument = MusicXmlDocument.parse(xmlContent);

  group('parseMxl', () {
    test('parses .mxl with META-INF/container.xml', () {
      final archive = _createMxlArchive(xmlContent);
      final mxlBytes = ZipEncoder().encode(archive);

      final mxlDocument = MusicXmlDocument.parseMxl(mxlBytes);

      expect(mxlDocument.title, xmlDocument.title);
      expect(mxlDocument.score.parts.length, xmlDocument.score.parts.length);
      expect(
        mxlDocument.score.parts.first.measures.length,
        xmlDocument.score.parts.first.measures.length,
      );
      expect(
          mxlDocument.totalTimeSecs, closeTo(xmlDocument.totalTimeSecs, 0.1));
    });

    test('falls back to first .xml file when container.xml is absent', () {
      final archive = _createMxlArchive(xmlContent, includeContainer: false);
      final mxlBytes = ZipEncoder().encode(archive);

      final mxlDocument = MusicXmlDocument.parseMxl(mxlBytes);

      expect(mxlDocument.title, xmlDocument.title);
      expect(mxlDocument.score.parts.length, xmlDocument.score.parts.length);
    });

    test('throws FormatException when archive has no .xml files', () {
      final archive = Archive();
      archive.addFile(ArchiveFile.bytes('readme.txt', utf8.encode('hello')));
      final mxlBytes = ZipEncoder().encode(archive);

      expect(
        () => MusicXmlDocument.parseMxl(mxlBytes),
        throwsA(isA<FormatException>()),
      );
    });

    test('skips META-INF .xml files in fallback', () {
      final archive = Archive();
      archive.addFile(
        ArchiveFile.bytes(
          'META-INF/other.xml',
          utf8.encode('<other/>'),
        ),
      );
      archive.addFile(ArchiveFile.bytes('score.xml', utf8.encode(xmlContent)));
      final mxlBytes = ZipEncoder().encode(archive);

      final mxlDocument = MusicXmlDocument.parseMxl(mxlBytes);
      expect(mxlDocument.title, xmlDocument.title);
    });
  });
}
