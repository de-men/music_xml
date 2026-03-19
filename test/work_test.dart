import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/data_types/xlink.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/work-element/
final asset = File('test/assets/work-element.xml');

void main() {
  test('<work> with work-number, work-title, and opus', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    final work = document.score.work;
    expect(work, isNotNull);
    expect(work!.workNumber!.innerText, 'D. 911');
    expect(work.workTitle!.innerText, 'Winterreise');
    expect(work.opus!.href.value, 'opus/winterreise.musicxml');
    expect(work.opus!.show!.show, XLinkShow.newWindow);
  });

  test('<work> coexists with movement-number and movement-title', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    expect(document.score.work!.workTitle!.title, 'Winterreise');
    expect(document.score.movementNumber!.innerText, '22');
    expect(document.score.movementTitle!.innerText, 'Mut');
  });

  test('score without <work> has null work', () {
    final noWork = File('test/assets/pitch-element.xml');
    final document = MusicXmlDocument.parse(noWork.readAsStringSync());

    expect(document.score.work, isNull);
  });
}
