import 'package:xml/xml.dart';

import '../../../attributes/token_attribute.dart';
import '../../../data_types/start_stop.dart';
import '../../../local.dart';
import '../../footnote.dart';
import '../../level.dart';
import 'group_abbreviation.dart';
import 'group_abbreviation_display.dart';
import 'group_barline.dart';
import 'group_name.dart';
import 'group_name_display.dart';
import 'group_symbol.dart';
import 'group_time.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/part-group/
class PartGroup extends XmlElement {
  final StartStopAttr type;
  final TokenAttr? number;

  final GroupName? groupName;
  final GroupNameDisplay? groupNameDisplay;
  final GroupAbbreviation? groupAbbreviation;
  final GroupAbbreviationDisplay? groupAbbreviationDisplay;
  final GroupSymbol? groupSymbol;
  final GroupBarline? groupBarline;
  final GroupTime? groupTime;
  final Footnote? footnote;
  final Level? level;

  factory PartGroup.parse(XmlElement element) {
    late final StartStopAttr type;
    TokenAttr? number;
    element.attributes.forEach((e) {
      switch (e.name.local) {
        case Local.type:
          type = StartStopAttr(e.name.local, parseStartStop(e.value));
          break;
        case Local.number:
          number = TokenAttr(e.name.local, e.value);
          break;
      }
    });

    GroupName? groupName;
    GroupNameDisplay? groupNameDisplay;
    GroupAbbreviation? groupAbbreviation;
    GroupAbbreviationDisplay? groupAbbreviationDisplay;
    GroupSymbol? groupSymbol;
    GroupBarline? groupBarline;
    GroupTime? groupTime;
    Footnote? footnote;
    Level? level;

    element.childElements.forEach((e) {
      switch (e.name.local) {
        case Local.groupName:
          groupName = GroupName.parse(e);
          break;
        case Local.groupNameDisplay:
          groupNameDisplay = GroupNameDisplay.parse(e);
          break;
        case Local.groupAbbreviation:
          groupAbbreviation = GroupAbbreviation.parse(e);
          break;
        case Local.groupAbbreviationDisplay:
          groupAbbreviationDisplay = GroupAbbreviationDisplay.parse(e);
          break;
        case Local.groupSymbol:
          groupSymbol = GroupSymbol.parse(e);
          break;
        case Local.groupBarline:
          groupBarline = GroupBarline.parse(e);
          break;
        case Local.groupTime:
          groupTime = GroupTime.parse(e);
          break;
        case Local.footnote:
          footnote = Footnote.parse(e);
          break;
        case Local.level:
          level = Level.parse(e);
          break;
      }
    });

    return PartGroup(
      type: type,
      number: number,
      groupName: groupName,
      groupNameDisplay: groupNameDisplay,
      groupAbbreviation: groupAbbreviation,
      groupAbbreviationDisplay: groupAbbreviationDisplay,
      groupSymbol: groupSymbol,
      groupBarline: groupBarline,
      groupTime: groupTime,
      footnote: footnote,
      level: level,
    );
  }

  PartGroup({
    required this.type,
    this.number,
    this.groupName,
    this.groupNameDisplay,
    this.groupAbbreviation,
    this.groupAbbreviationDisplay,
    this.groupSymbol,
    this.groupBarline,
    this.groupTime,
    this.footnote,
    this.level,
  }) : super.tag(
          Local.partGroup,
          attributes: [
            type,
            if (number != null) number,
          ],
          children: [
            if (groupName != null) groupName,
            if (groupNameDisplay != null) groupNameDisplay,
            if (groupAbbreviation != null) groupAbbreviation,
            if (groupAbbreviationDisplay != null) groupAbbreviationDisplay,
            if (groupSymbol != null) groupSymbol,
            if (groupBarline != null) groupBarline,
            if (groupTime != null) groupTime,
            if (footnote != null) footnote,
            if (level != null) level,
          ],
        );
}
