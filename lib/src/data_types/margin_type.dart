/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/margin-type/
enum MarginType { both, even, odd }

MarginType? parseMarginType(String? str) {
  if (str == null) return null;
  switch (str) {
    case 'both':
      return MarginType.both;
    case 'even':
      return MarginType.even;
    case 'odd':
      return MarginType.odd;
    default:
      return null;
  }
}
