/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/font-style/
enum FontStyle { normal, italic }

FontStyle? parseFontStyle(String? str) {
  if (str == null) return null;
  switch (str) {
    case 'normal':
      return FontStyle.normal;
    case 'italic':
      return FontStyle.italic;
    default:
      return null;
  }
}
