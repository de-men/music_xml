import 'package:xml/xml.dart';

import '../../local.dart';
import 'creator.dart';
import 'encoding.dart';
import 'miscellaneous.dart';
import 'relation.dart';
import 'rights.dart';
import 'source.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/identification/
class Identification extends XmlElement {
  final List<Creator> creators;
  final List<Rights> rights;
  final Encoding? encoding;
  final Source? source;
  final List<Relation> relations;
  final Miscellaneous? miscellaneous;

  factory Identification.parse(XmlElement element) {
    final creators = <Creator>[];
    final rights = <Rights>[];
    Encoding? encoding;
    Source? source;
    final relations = <Relation>[];
    Miscellaneous? miscellaneous;

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.creator:
          creators.add(Creator.parse(child));
          break;
        case Local.rights:
          rights.add(Rights.parse(child));
          break;
        case Local.encoding:
          encoding = Encoding.parse(child);
          break;
        case Local.source:
          source = Source.parse(child);
          break;
        case Local.relation:
          relations.add(Relation.parse(child));
          break;
        case Local.miscellaneous:
          miscellaneous = Miscellaneous.parse(child);
          break;
      }
    }

    return Identification(
      creators: creators,
      rights: rights,
      encoding: encoding,
      source: source,
      relations: relations,
      miscellaneous: miscellaneous,
    );
  }

  Identification({
    this.creators = const [],
    this.rights = const [],
    this.encoding,
    this.source,
    this.relations = const [],
    this.miscellaneous,
  }) : super.tag(
          Local.identification,
          children: [
            ...creators,
            ...rights,
            if (encoding != null) encoding,
            if (source != null) source,
            ...relations,
            if (miscellaneous != null) miscellaneous,
          ],
        );
}
