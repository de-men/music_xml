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
    expect(id.creators[0].innerText, 'Claude Debussy');
    expect(id.creators[1].type, 'lyricist');
    expect(id.creators[1].innerText, 'Paul Bourget');

    expect(id.rights.length, 1);
    expect(id.rights.first.innerText, contains('Recordare LLC'));

    expect(id.encoding, isNotNull);
    expect(id.encoding!.software.first, 'Finale for Windows');
    expect(id.encoding!.encodingDates.first, '2010-12-17');
    expect(id.encoding!.encoders.first.value, 'Mark D. Lew');
    expect(id.encoding!.encoders.first.type, isNull);
    expect(id.encoding!.encodingDescriptions.first, 'MusicXML example');
    expect(id.encoding!.supports.length, 3);
    expect(id.encoding!.supports.first.element, 'accidental');
    expect(id.encoding!.supports.first.type, isTrue);

    expect(id.source!.value, contains('Girod'));

    expect(id.relations.length, 1);
    expect(id.relations.first.value, 'urn:ISBN:0-486-24131-9');

    expect(id.miscellaneous, isNotNull);
    expect(id.miscellaneous!.fields.length, 1);
    expect(id.miscellaneous!.fields.first.fieldName, 'difficulty-level');
    expect(id.miscellaneous!.fields.first.value, '3');
  });

  test('<supports> with attribute and value', () {
    final document = MusicXmlDocument.parse(supportsAsset.readAsStringSync());

    final encoding = document.score.identification!.encoding!;
    expect(encoding.software.first, 'My Notation Software');
    expect(encoding.encodingDates.first, '2021-04-26');

    expect(encoding.supports.length, 2);

    final systemSupport = encoding.supports[0];
    expect(systemSupport.type, isTrue);
    expect(systemSupport.element, 'print');
    expect(systemSupport.attribute, 'new-system');
    expect(systemSupport.value, 'yes');

    final pageSupport = encoding.supports[1];
    expect(pageSupport.type, isFalse);
    expect(pageSupport.element, 'print');
    expect(pageSupport.attribute, 'new-page');
    expect(pageSupport.value, 'yes');
  });

  test('score without <identification> has null identification', () {
    final noId = File('test/assets/pitch-element.xml');
    final document = MusicXmlDocument.parse(noId.readAsStringSync());

    expect(document.score.identification, isNull);
  });
}
