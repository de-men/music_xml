import 'package:xml/xml.dart';

import '../../attributes/id.dart';
import '../../attributes/int_attribute.dart';
import '../../local.dart';
import '../bookmark.dart';
import '../link.dart';
import 'credit_image.dart';
import 'credit_symbol.dart';
import 'credit_type.dart';
import 'credit_words.dart';

export '../bookmark.dart';
export '../link.dart';
export 'credit_image.dart';
export 'credit_symbol.dart';
export 'credit_type.dart';
export 'credit_words.dart';

/// Represents either `<credit-words>` or `<credit-symbol>`.
sealed class CreditContent {}

class CreditWordsContent extends CreditContent {
  final CreditWords creditWords;
  CreditWordsContent(this.creditWords);
}

class CreditSymbolContent extends CreditContent {
  final CreditSymbol creditSymbol;
  CreditSymbolContent(this.creditSymbol);
}

/// A group of (links, bookmarks, content) in the "zero or more" repetition.
class CreditContentGroup {
  final List<Link> links;
  final List<Bookmark> bookmarks;
  final CreditContent content;

  CreditContentGroup({
    this.links = const [],
    this.bookmarks = const [],
    required this.content,
  });
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/credit/
class Credit extends XmlElement {
  final IntAttr? page;
  final Id? id;
  final List<CreditType> creditTypes;
  final List<Link> links;
  final List<Bookmark> bookmarks;

  /// Exactly one of: [creditImage] or text content ([first] + [rest]).
  final CreditImage? creditImage;

  /// Required first credit-words or credit-symbol (null if image credit).
  final CreditContent? first;

  /// Zero or more additional (links, bookmarks, content) groups.
  final List<CreditContentGroup> rest;

  bool get isImageCredit => creditImage != null;

  /// All content items in order (first + rest).
  List<CreditContent> get contents =>
      first != null ? [first!, ...rest.map((g) => g.content)] : const [];

  /// Convenience: all CreditWords in this credit.
  List<CreditWords> get creditWords => contents
      .whereType<CreditWordsContent>()
      .map((c) => c.creditWords)
      .toList();

  /// Convenience: all CreditSymbols in this credit.
  List<CreditSymbol> get creditSymbols => contents
      .whereType<CreditSymbolContent>()
      .map((c) => c.creditSymbol)
      .toList();

  factory Credit.parse(XmlElement element) {
    IntAttr? page;
    Id? id;

    for (final attr in element.attributes) {
      final v = attr.value;
      switch (attr.name.local) {
        case 'page':
          final parsed = int.tryParse(v);
          if (parsed != null) page = IntAttr(parsed, 'page');
          break;
        case Local.id:
          id = Id(v);
          break;
      }
    }

    final creditTypes = <CreditType>[];
    final topLinks = <Link>[];
    final topBookmarks = <Bookmark>[];
    CreditImage? creditImage;
    CreditContent? first;
    final rest = <CreditContentGroup>[];

    var groupLinks = <Link>[];
    var groupBookmarks = <Bookmark>[];

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.creditType:
          creditTypes.add(CreditType.parse(child));
          break;
        case Local.link:
          final link = Link.parse(child);
          if (first == null && creditImage == null) {
            topLinks.add(link);
          } else {
            groupLinks.add(link);
          }
          break;
        case Local.bookmark:
          final bookmark = Bookmark.parse(child);
          if (first == null && creditImage == null) {
            topBookmarks.add(bookmark);
          } else {
            groupBookmarks.add(bookmark);
          }
          break;
        case Local.creditWords:
          final content = CreditWordsContent(CreditWords.parse(child));
          if (first == null) {
            first = content;
          } else {
            rest.add(CreditContentGroup(
              links: groupLinks,
              bookmarks: groupBookmarks,
              content: content,
            ));
            groupLinks = <Link>[];
            groupBookmarks = <Bookmark>[];
          }
          break;
        case Local.creditSymbol:
          final content = CreditSymbolContent(CreditSymbol.parse(child));
          if (first == null) {
            first = content;
          } else {
            rest.add(CreditContentGroup(
              links: groupLinks,
              bookmarks: groupBookmarks,
              content: content,
            ));
            groupLinks = <Link>[];
            groupBookmarks = <Bookmark>[];
          }
          break;
        case Local.creditImage:
          creditImage = CreditImage.parse(child);
          break;
      }
    }

    if (creditImage != null) {
      return Credit.image(
        page: page,
        id: id,
        creditTypes: creditTypes,
        links: topLinks,
        bookmarks: topBookmarks,
        creditImage: creditImage,
      );
    }
    return Credit.content(
      page: page,
      id: id,
      creditTypes: creditTypes,
      links: topLinks,
      bookmarks: topBookmarks,
      first: first!,
      rest: rest,
    );
  }

  Credit.image({
    this.page,
    this.id,
    this.creditTypes = const [],
    this.links = const [],
    this.bookmarks = const [],
    required CreditImage this.creditImage,
  })  : first = null,
        rest = const [],
        super.tag(
          Local.credit,
          attributes: [
            if (page != null) page,
            if (id != null) id,
          ],
          children: [
            ...creditTypes,
            ...links,
            ...bookmarks,
            creditImage,
          ],
        );

  Credit.content({
    this.page,
    this.id,
    this.creditTypes = const [],
    this.links = const [],
    this.bookmarks = const [],
    required CreditContent this.first,
    this.rest = const [],
  })  : creditImage = null,
        super.tag(
          Local.credit,
          attributes: [
            if (page != null) page,
            if (id != null) id,
          ],
          children: [
            ...creditTypes,
            ...links,
            ...bookmarks,
            _contentToElement(first),
            ...rest.expand((g) => [
                  ...g.links,
                  ...g.bookmarks,
                  _contentToElement(g.content),
                ]),
          ],
        );

  static XmlElement _contentToElement(CreditContent c) => switch (c) {
        CreditWordsContent c => c.creditWords,
        CreditSymbolContent c => c.creditSymbol,
      };
}
