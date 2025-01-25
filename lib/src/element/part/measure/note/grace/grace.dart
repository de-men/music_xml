import 'package:music_xml/src/element/part/measure/note/grace/make_time.dart';
import 'package:music_xml/src/element/part/measure/note/grace/slash.dart';
import 'package:music_xml/src/element/part/measure/note/grace/steal_time_following.dart';
import 'package:music_xml/src/element/part/measure/note/grace/steal_time_previous.dart';
import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

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
      if (attribute.name.local == Local.makeTime) {
        makeTime = MakeTime.parse(attribute);
      }
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
    return Grace(
      makeTime,
      slash,
      stealTimeFollowing,
      stealTimePrevious,
    );
  }

  Grace(
    this.makeTime,
    this.slash,
    this.stealTimeFollowing,
    this.stealTimePrevious,
  ) : super(
          XmlName(Local.grace),
          [
            if (makeTime != null) makeTime,
            if (slash != null) slash,
            if (stealTimeFollowing != null) stealTimeFollowing,
            if (stealTimePrevious != null) stealTimePrevious,
          ],
        );
}
