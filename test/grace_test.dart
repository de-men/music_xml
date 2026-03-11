import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/grace-element-appoggiatura/
final appoggiatura = File('test/assets/grace-element-appoggiatura.xml');
final makeTimeAsset = File('test/assets/grace-element-make-time.xml');

void main() {
  test('<grace> (Appoggiatura)', () {
    final document = MusicXmlDocument.parse(appoggiatura.readAsStringSync());

    final grace =
        document.score.parts.single.measures.single.notes.single.grace;
    expect(grace!.slash!.yesNo, isFalse);
    expect(grace.stealTimeFollowing!.percent, 33);
    expect(grace.makeTime, isNull);
  });

  test('<grace> with make-time', () {
    final document = MusicXmlDocument.parse(makeTimeAsset.readAsStringSync());

    final grace =
        document.score.parts.single.measures.single.notes.single.grace;
    expect(grace!.makeTime!.divisions, 100);
    expect(grace.slash!.yesNo, isTrue);
    expect(grace.stealTimeFollowing, isNull);
    expect(grace.stealTimePrevious, isNull);
  });
}
