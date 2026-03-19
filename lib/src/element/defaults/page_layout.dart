import 'package:xml/xml.dart';

import '../../data_type/margin_type.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/page-margins/
class PageMargins extends XmlElement {
  final MarginType? type;
  final double leftMargin;
  final double rightMargin;
  final double topMargin;
  final double bottomMargin;

  factory PageMargins.parse(XmlElement element) {
    return PageMargins(
      type: parseMarginType(element.getAttribute('type')),
      leftMargin: _parseDouble(element, 'left-margin'),
      rightMargin: _parseDouble(element, 'right-margin'),
      topMargin: _parseDouble(element, 'top-margin'),
      bottomMargin: _parseDouble(element, 'bottom-margin'),
    );
  }

  static double _parseDouble(XmlElement parent, String name) {
    return double.parse(parent.getElement(name)?.innerText ?? '0');
  }

  PageMargins({
    this.type,
    required this.leftMargin,
    required this.rightMargin,
    required this.topMargin,
    required this.bottomMargin,
  }) : super.tag(Local.pageMargins);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/page-layout/
class PageLayout extends XmlElement {
  final double? pageHeight;
  final double? pageWidth;
  final List<PageMargins> pageMargins;

  factory PageLayout.parse(XmlElement element) {
    return PageLayout(
      pageHeight: _optDouble(element, 'page-height'),
      pageWidth: _optDouble(element, 'page-width'),
      pageMargins: element
          .findElements(Local.pageMargins)
          .map((e) => PageMargins.parse(e))
          .toList(),
    );
  }

  static double? _optDouble(XmlElement parent, String name) {
    final el = parent.getElement(name);
    return el != null ? double.parse(el.innerText) : null;
  }

  PageLayout({this.pageHeight, this.pageWidth, this.pageMargins = const []})
      : super.tag(Local.pageLayout);
}
