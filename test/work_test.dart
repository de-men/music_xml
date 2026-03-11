import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/work-element/
final asset = File('test/assets/work-element.xml');

void main() {
  test('<work> with work-number, work-title, and opus', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    final work = document.score.work;
    expect(work, isNotNull);
    expect(work!.workNumber!.number, 'D. 911');
    expect(work.workTitle!.title, 'Winterreise');
    expect(work.opus!.href, 'opus/winterreise.musicxml');
    expect(work.opus!.show, 'new');
  });

  test('<work> coexists with movement-number and movement-title', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    expect(document.score.work!.workTitle!.title, 'Winterreise');
    expect(document.score.movementNumber!.number, '22');
    expect(document.score.movementTitle!.title, 'Mut');
  });

  test('score without <work> has null work', () {
    final noWork = File('test/assets/pitch-element.xml');
    final document = MusicXmlDocument.parse(noWork.readAsStringSync());

    expect(document.score.work, isNull);
  });
}
