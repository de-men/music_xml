import 'package:xml/xml.dart';

import '../../local.dart';
import 'scorepart/score_part.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/part-list/
class PartList extends XmlElement {
  // TODO final Map<PartGroup> partGroups; // Zero or more times
  final Map<String, ScorePart> scoreParts;

  factory PartList.fromXml(XmlElement element) {
    return PartList(
      scoreParts: Map.fromIterable(
        element.findElements(Local.scorePart).map((e) => ScorePart.parse(e)),
        key: (e) => e.id.value,
      ),
    );
  }

  PartList({
    required this.scoreParts,
  }) : super.tag(Local.partList);
}
