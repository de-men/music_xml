import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/grace-element-appoggiatura/
final asset = File('test/assets/grace-element-appoggiatura.xml');

void main() {
  test('<grace> (Appoggiatura)', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    final grace =
        document.score.parts.single.measures.single.notes.single.grace;
    expect(grace!.slash!.yesNo, isFalse);
    expect(grace.stealTimeFollowing!.percent, 33);
  });
}
