import 'package:xml/xml.dart';

import '../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/bookmark/
class Bookmark extends XmlElement {
  final String bookmarkId;
  final String? element;
  final String? bookmarkName;
  final int? position;

  factory Bookmark.parse(XmlElement e) {
    return Bookmark(
      bookmarkId: e.getAttribute('id') ?? '',
      element: e.getAttribute('element'),
      bookmarkName: e.getAttribute('name'),
      position: int.tryParse(e.getAttribute('position') ?? ''),
    );
  }

  Bookmark({
    required this.bookmarkId,
    this.element,
    this.bookmarkName,
    this.position,
  }) : super.tag(Local.bookmark);
}
