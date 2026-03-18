/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/xlink-actuate/
enum XLinkActuate { onRequest, onLoad, other, none }

const _xLinkActuateMap = {
  'onRequest': XLinkActuate.onRequest,
  'onLoad': XLinkActuate.onLoad,
  'other': XLinkActuate.other,
  'none': XLinkActuate.none,
};

XLinkActuate? parseXLinkActuate(String? str) =>
    str != null ? _xLinkActuateMap[str] : null;

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/xlink-show/
enum XLinkShow { newWindow, replace, embed, other, none }

const _xLinkShowMap = {
  'new': XLinkShow.newWindow,
  'replace': XLinkShow.replace,
  'embed': XLinkShow.embed,
  'other': XLinkShow.other,
  'none': XLinkShow.none,
};

XLinkShow? parseXLinkShow(String? str) =>
    str != null ? _xLinkShowMap[str] : null;

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/xlink-type/
enum XLinkType { simple }

XLinkType? parseXLinkType(String? str) {
  if (str == 'simple') return XLinkType.simple;
  return null;
}
