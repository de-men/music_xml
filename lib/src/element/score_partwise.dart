import 'dart:math';

import 'package:music_xml/src/element/movement_title.dart';
import 'package:xml/xml.dart';

import '../../music_xml.dart';
import '../local.dart';
import 'movement_number.dart';
import 'partlist/part_list.dart';
import 'version.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/score-partwise/
class ScorePartwise extends XmlElement {
  final Version? version;

  // TODO final Work? work;
  final MovementNumber? movementNumber;
  final MovementTitle? movementTitle;

  // TODO final Identification? identification;
  // TODO final Defaults? defaults;

  // TODO final List<Credit> credits; // Zero or more times
  final PartList partList;

  // One or more times
  final List<Part> parts;

  // Extension
  final double totalTimeSecs;

  /// Parse the uncompressed MusicXML document.
  factory ScorePartwise.parse(XmlElement element) {
    final versionAttribute = element.getAttribute(Local.version);
    final version = versionAttribute != null ? Version(versionAttribute) : null;

    final state = MusicXMLParserState();
    var totalTimeSecs = 0.0;

    MovementNumber? movementNumber = null;
    MovementTitle? movementTitle = null;
    final partList = PartList.parse(element.getElement(Local.partList)!);
    final parts = <Part>[];
    element.childElements.forEach((e) {
      switch (e.name.local) {
        case Local.movementNumber:
          movementNumber = MovementNumber.parse(e);
          break;
        case Local.movementTitle:
          movementTitle = MovementTitle.parse(e);
          break;
        case Local.part:
          parts.add(Part.parse(state, e, partList.scoreParts));
          totalTimeSecs = max(totalTimeSecs, state.timePosition);
          break;
      }
    });

    return ScorePartwise(
      version: version,
      movementNumber: movementNumber,
      movementTitle: movementTitle,
      partList: partList,
      parts: parts,
      totalTimeSecs: totalTimeSecs,
    );
  }

  ScorePartwise({
    this.version,
    // this.work,
    this.movementNumber,
    this.movementTitle,
    // this.identification,
    // this.defaults,
    // this.credits = const [],
    required this.partList,
    required this.parts,
    required this.totalTimeSecs,
  }) : super.tag(
          Local.scorePartwise,
          attributes: [if (version != null) version],
          children: [
            if (movementNumber != null) movementNumber,
            if (movementTitle != null) movementTitle,
            partList,
            ...parts,
          ],
        );
}
