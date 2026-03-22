import 'package:xml/xml.dart';

import '../../../../../attributes/make_time.dart';
import '../../../../../attributes/slash.dart';
import '../../../../../attributes/steal_time_following.dart';
import '../../../../../attributes/steal_time_previous.dart';
import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/grace/
class Grace extends XmlElement {
  final MakeTime? makeTime;
  final Slash? slash;
  final StealTimeFollowing? stealTimeFollowing;
  final StealTimePrevious? stealTimePrevious;

  factory Grace.parse(XmlElement element) {
    MakeTime? makeTime;
    Slash? slash;
    StealTimeFollowing? stealTimeFollowing;
    StealTimePrevious? stealTimePrevious;
    for (final attribute in element.attributes) {
      switch (attribute.name.local) {
        case Local.makeTime:
          makeTime = MakeTime.parse(attribute);
          break;
        case Local.slash:
          slash = Slash.parse(attribute);
          break;
        case Local.stealTimeFollowing:
          stealTimeFollowing = StealTimeFollowing.parse(attribute);
          break;
        case Local.stealTimePrevious:
          stealTimePrevious = StealTimePrevious.parse(attribute);
          break;
      }
    }
    return Grace(makeTime, slash, stealTimeFollowing, stealTimePrevious);
  }

  Grace(
    this.makeTime,
    this.slash,
    this.stealTimeFollowing,
    this.stealTimePrevious,
  ) : super.tag(
          Local.grace,
          attributes: [
            if (makeTime != null) makeTime,
            if (slash != null) slash,
            if (stealTimeFollowing != null) stealTimeFollowing,
            if (stealTimePrevious != null) stealTimePrevious,
          ],
        );
}
