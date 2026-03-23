import 'package:xml/xml.dart';

import '../../local.dart';
import 'partgroup/part_group.dart';
import 'scorepart/score_part.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/part-list/
class PartList extends XmlElement {
  final List<PartGroup> partGroups;
  final Map<String, ScorePart> scoreParts;

  /// Ordered list of part-group and score-part elements, preserving the
  /// interleaved sequence from the original XML.
  final List<XmlElement> items;

  factory PartList.parse(XmlElement element) {
    final partGroups = <PartGroup>[];
    final scoreParts = <String, ScorePart>{};
    final items = <XmlElement>[];

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.partGroup:
          final partGroup = PartGroup.parse(child);
          partGroups.add(partGroup);
          items.add(partGroup);
          break;
        case Local.scorePart:
          final scorePart = ScorePart.parse(child);
          scoreParts[scorePart.id.value] = scorePart;
          items.add(scorePart);
          break;
      }
    }

    return PartList(
      partGroups: partGroups,
      scoreParts: scoreParts,
      items: items,
    );
  }

  PartList({
    this.partGroups = const [],
    required this.scoreParts,
    List<XmlElement>? items,
  })  : items = items ?? [...scoreParts.values],
        super.tag(
          Local.partList,
          children: items ?? [...scoreParts.values],
        );
}
