/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/text-direction/
enum TextDirection { ltr, rtl, lro, rlo }

TextDirection? parseTextDirection(String? str) {
  if (str == null) return null;
  switch (str) {
    case 'ltr':
      return TextDirection.ltr;
    case 'rtl':
      return TextDirection.rtl;
    case 'lro':
      return TextDirection.lro;
    case 'rlo':
      return TextDirection.rlo;
    default:
      return null;
  }
}
