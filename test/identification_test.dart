import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/identification-element/
final asset = File('test/assets/identification-element.xml');
// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/supports-element/
final supportsAsset = File('test/assets/supports-element.xml');

void main() {
  test('<identification> with creators, rights, encoding, source, relation',
      () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    final id = document.score.identification;
    expect(id, isNotNull);

    expect(id!.creators.length, 2);
    expect(id.creators[0].type, 'composer');
    expect(id.creators[0].content, 'Claude Debussy');
    expect(id.creators[1].type, 'lyricist');
    expect(id.creators[1].content, 'Paul Bourget');

    expect(id.rights.length, 1);
    expect(id.rights.first.content, contains('Recordare LLC'));

    expect(id.encoding, isNotNull);
    expect(id.encoding!.software.length, greaterThan(0));
    expect(id.encoding!.encodingDates.length, greaterThan(0));
    expect(id.encoding!.encoders.first.content, 'Mark D. Lew');
    expect(id.encoding!.encoders.first.type, isNull);
    expect(id.encoding!.supports.length, 3);
    expect(id.encoding!.supports.first.element.value, 'accidental');
    expect(id.encoding!.supports.first.type.value, 'yes');

    expect(id.source!.content, contains('Girod'));

    expect(id.relations.length, 1);
    expect(id.relations.first.content, 'urn:ISBN:0-486-24131-9');

    expect(id.miscellaneous, isNotNull);
    expect(id.miscellaneous!.fields.length, 1);
    expect(id.miscellaneous!.fields.first.fieldName, 'difficulty-level');
    expect(id.miscellaneous!.fields.first.content, '3');
  });

  test('<supports> with attribute and value', () {
    final document = MusicXmlDocument.parse(supportsAsset.readAsStringSync());

    final encoding = document.score.identification!.encoding!;

    expect(encoding.supports.length, 2);

    final systemSupport = encoding.supports[0];
    expect(systemSupport.type.value, 'yes');
    expect(systemSupport.element.value, 'print');
    expect(systemSupport.attribute?.value, 'new-system');
    expect(systemSupport.valueAttr?.value, 'yes');

    final pageSupport = encoding.supports[1];
    expect(pageSupport.type.value, 'no');
    expect(pageSupport.element.value, 'print');
    expect(pageSupport.attribute?.value, 'new-page');
    expect(pageSupport.valueAttr?.value, 'yes');
  });

  test('score without <identification> has null identification', () {
    final noId = File('test/assets/pitch-element.xml');
    final document = MusicXmlDocument.parse(noId.readAsStringSync());

    expect(document.score.identification, isNull);
  });
}
