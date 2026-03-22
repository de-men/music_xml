import 'package:music_xml/src/attributes/id.dart';
import 'package:xml/xml.dart';

import '../attributes/int_attribute.dart';
import '../attributes/token_attribute.dart';
import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/bookmark/
class Bookmark extends XmlElement {
  final Id bookmarkId;
  final TokenAttr? element;
  final TokenAttr? bookmarkName;
  final IntAttr? position;

  factory Bookmark.parse(XmlElement e) {
    late Id bookmarkId;
    TokenAttr? element;
    TokenAttr? bookmarkName;
    IntAttr? position;

    for (final child in e.childElements) {
      switch (child.name.local) {
        case Local.id:
          bookmarkId = Id(child.innerText);
          break;
        case Local.element:
          element = TokenAttr(Local.element, child.innerText);
          break;
        case Local.name:
          bookmarkName = TokenAttr(Local.name, child.innerText);
          break;
        case Local.position:
          position = IntAttr(int.parse(child.innerText), Local.position);
          break;
        default:
          break;
      }
    }
    return Bookmark(
      bookmarkId: bookmarkId,
      element: element,
      bookmarkName: bookmarkName,
      position: position,
    );
  }

  Bookmark({
    required this.bookmarkId,
    this.element,
    this.bookmarkName,
    this.position,
  }) : super.tag(
          Local.bookmark,
          attributes: [
            bookmarkId,
            if (element != null) element,
            if (bookmarkName != null) bookmarkName,
            if (position != null) position,
          ],
        );
}
