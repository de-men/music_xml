import 'package:xml/xml.dart';

import '../../local.dart';
import 'opus.dart';
import 'work_number.dart';
import 'work_title.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/work/
class Work extends XmlElement {
  final WorkNumber? workNumber;
  final WorkTitle? workTitle;
  final Opus? opus;

  factory Work.parse(XmlElement element) {
    WorkNumber? workNumber;
    WorkTitle? workTitle;
    Opus? opus;
    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.workNumber:
          workNumber = WorkNumber.parse(child);
          break;
        case Local.workTitle:
          workTitle = WorkTitle.parse(child);
          break;
        case Local.opus:
          opus = Opus.parse(child);
          break;
      }
    }
    return Work(workNumber: workNumber, workTitle: workTitle, opus: opus);
  }

  Work({this.workNumber, this.workTitle, this.opus})
      : super.tag(
          Local.work,
          children: [
            if (workNumber != null) workNumber,
            if (workTitle != null) workTitle,
            if (opus != null) opus,
          ],
        );
}
