import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/data_types/start_stop.dart';
import 'package:music_xml/src/local.dart';
import 'package:music_xml/src/elements/partlist/partgroup/group_abbreviation.dart';
import 'package:music_xml/src/elements/partlist/partgroup/group_barline.dart';
import 'package:music_xml/src/elements/partlist/partgroup/group_name.dart';
import 'package:music_xml/src/elements/partlist/partgroup/group_symbol.dart';
import 'package:music_xml/src/elements/partlist/partgroup/group_time.dart';
import 'package:music_xml/src/elements/footnote.dart';
import 'package:music_xml/src/elements/level.dart';
import 'package:test/test.dart';

final asset = File('test/assets/part-group-element.xml');
final multipleScorePartsAsset = File('test/assets/multipleScoreParts.xml');

void main() {
  test('<part-group> with group-name, group-symbol, group-barline', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());
    final partList = document.score.partList;

    expect(partList.partGroups.length, 4);
    expect(partList.scoreParts.length, 4);

    final windsStart = partList.partGroups[0];
    expect(windsStart.type.startStop, StartStop.start);
    expect(windsStart.number?.value, '1');
    expect(windsStart.groupName, isA<GroupName>());
    expect(windsStart.groupName!.content, 'Winds');
    expect(windsStart.groupAbbreviation, isA<GroupAbbreviation>());
    expect(windsStart.groupAbbreviation!.content, 'Wds.');
    expect(windsStart.groupSymbol, isA<GroupSymbol>());
    expect(windsStart.groupSymbol!.groupSymbolValue, GroupSymbolValue.bracket);
    expect(windsStart.groupBarline, isA<GroupBarline>());
    expect(windsStart.groupBarline!.groupBarlineValue, GroupBarlineValue.yes);
    expect(windsStart.groupTime, isNull);
    expect(windsStart.footnote, isA<Footnote>());
    expect(windsStart.footnote!.content, '*) See original edition.');
    expect(windsStart.level, isA<Level>());
    expect(windsStart.level!.content, '2');

    final windsStop = partList.partGroups[1];
    expect(windsStop.type.startStop, StartStop.stop);
    expect(windsStop.number?.value, '1');
    expect(windsStop.groupName, isNull);

    final stringsStart = partList.partGroups[2];
    expect(stringsStart.type.startStop, StartStop.start);
    expect(stringsStart.number?.value, '2');
    expect(stringsStart.groupName!.content, 'Strings');
    expect(stringsStart.groupSymbol!.groupSymbolValue, GroupSymbolValue.brace);
    expect(stringsStart.groupBarline!.groupBarlineValue,
        GroupBarlineValue.mensurstrich);
    expect(stringsStart.groupTime, isA<GroupTime>());
  });

  test('<part-group> preserves interleaved item order', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());
    final items = document.score.partList.items;

    expect(items.length, 8);
    expect(items[0], isA<PartGroup>());
    expect(items[1], isA<ScorePart>());
    expect(items[2], isA<ScorePart>());
    expect(items[3], isA<PartGroup>());
    expect(items[4], isA<PartGroup>());
    expect(items[5], isA<ScorePart>());
    expect(items[6], isA<ScorePart>());
    expect(items[7], isA<PartGroup>());
  });

  test('existing multipleScoreParts.xml with <part-group> parses correctly',
      () {
    final document =
        MusicXmlDocument.parse(multipleScorePartsAsset.readAsStringSync());
    final partList = document.score.partList;

    expect(partList.partGroups.length, 2);
    expect(partList.scoreParts.length, 2);

    final start = partList.partGroups[0];
    expect(start.type.startStop, StartStop.start);
    expect(start.number?.value, '1');
    expect(start.groupSymbol!.groupSymbolValue, GroupSymbolValue.bracket);

    final stop = partList.partGroups[1];
    expect(stop.type.startStop, StartStop.stop);
    expect(stop.number?.value, '1');
  });

  test('<part-group> number attribute defaults to null when omitted', () {
    final group = PartGroup(type: StartStopAttr(Local.type, StartStop.start));
    expect(group.number, isNull);
  });

  test('score without <part-group> has empty partGroups list', () {
    final noGroupAsset = File('test/assets/pitch-element.xml');
    final document = MusicXmlDocument.parse(noGroupAsset.readAsStringSync());

    expect(document.score.partList.partGroups, isEmpty);
    expect(document.score.partList.scoreParts, isNotEmpty);
  });
}
