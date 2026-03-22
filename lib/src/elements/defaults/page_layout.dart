import 'package:xml/xml.dart';

import '../../data_types/margin_type.dart';
import '../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/left-margin/
class LeftMargin extends XmlElement {
  final double tenths;

  factory LeftMargin.parse(XmlElement element) {
    return LeftMargin(double.parse(element.innerText));
  }

  LeftMargin(this.tenths)
      : super.tag(Local.leftMargin, children: [XmlText('$tenths')]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/right-margin/
class RightMargin extends XmlElement {
  final double tenths;

  factory RightMargin.parse(XmlElement element) {
    return RightMargin(double.parse(element.innerText));
  }

  RightMargin(this.tenths)
      : super.tag(Local.rightMargin, children: [XmlText('$tenths')]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/top-margin/
class TopMargin extends XmlElement {
  final double tenths;

  factory TopMargin.parse(XmlElement element) {
    return TopMargin(double.parse(element.innerText));
  }

  TopMargin(this.tenths)
      : super.tag(Local.topMargin, children: [XmlText('$tenths')]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/bottom-margin/
class BottomMargin extends XmlElement {
  final double tenths;

  factory BottomMargin.parse(XmlElement element) {
    return BottomMargin(double.parse(element.innerText));
  }

  BottomMargin(this.tenths)
      : super.tag(Local.bottomMargin, children: [XmlText('$tenths')]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/page-height/
class PageHeight extends XmlElement {
  final double tenths;

  factory PageHeight.parse(XmlElement element) {
    return PageHeight(double.parse(element.innerText));
  }

  PageHeight(this.tenths)
      : super.tag(Local.pageHeight, children: [XmlText('$tenths')]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/page-width/
class PageWidth extends XmlElement {
  final double tenths;

  factory PageWidth.parse(XmlElement element) {
    return PageWidth(double.parse(element.innerText));
  }

  PageWidth(this.tenths)
      : super.tag(Local.pageWidth, children: [XmlText('$tenths')]);
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/page-margins/
class PageMargins extends XmlElement {
  final MarginTypeAttr? type;
  final LeftMargin leftMargin;
  final RightMargin rightMargin;
  final TopMargin topMargin;
  final BottomMargin bottomMargin;

  factory PageMargins.parse(XmlElement element) {
    final typeStr = element.getAttribute(Local.type);
    final marginType = parseMarginType(typeStr);

    late LeftMargin leftMargin;
    late RightMargin rightMargin;
    late TopMargin topMargin;
    late BottomMargin bottomMargin;

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.leftMargin:
          leftMargin = LeftMargin.parse(child);
          break;
        case Local.rightMargin:
          rightMargin = RightMargin.parse(child);
          break;
        case Local.topMargin:
          topMargin = TopMargin.parse(child);
          break;
        case Local.bottomMargin:
          bottomMargin = BottomMargin.parse(child);
          break;
      }
    }

    return PageMargins(
      type: marginType != null ? MarginTypeAttr(Local.type, marginType) : null,
      leftMargin: leftMargin,
      rightMargin: rightMargin,
      topMargin: topMargin,
      bottomMargin: bottomMargin,
    );
  }

  PageMargins({
    this.type,
    required this.leftMargin,
    required this.rightMargin,
    required this.topMargin,
    required this.bottomMargin,
  }) : super.tag(
          Local.pageMargins,
          attributes: [if (type != null) type],
          children: [leftMargin, rightMargin, topMargin, bottomMargin],
        );
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/page-layout/
class PageLayout extends XmlElement {
  final PageHeight? pageHeight;
  final PageWidth? pageWidth;
  final List<PageMargins> pageMargins;

  factory PageLayout.parse(XmlElement element) {
    PageHeight? pageHeight;
    PageWidth? pageWidth;
    final pageMargins = <PageMargins>[];

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.pageHeight:
          pageHeight = PageHeight.parse(child);
          break;
        case Local.pageWidth:
          pageWidth = PageWidth.parse(child);
          break;
        case Local.pageMargins:
          pageMargins.add(PageMargins.parse(child));
          break;
      }
    }

    return PageLayout(
      pageHeight: pageHeight,
      pageWidth: pageWidth,
      pageMargins: pageMargins,
    );
  }

  PageLayout({this.pageHeight, this.pageWidth, this.pageMargins = const []})
      : super.tag(
          Local.pageLayout,
          children: [
            if (pageHeight != null) pageHeight,
            if (pageWidth != null) pageWidth,
            ...pageMargins,
          ],
        );
}
