/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/font-weight/
enum FontWeight { normal, bold }

FontWeight? parseFontWeight(String? str) {
  if (str == null) return null;
  switch (str) {
    case 'normal':
      return FontWeight.normal;
    case 'bold':
      return FontWeight.bold;
    default:
      return null;
  }
}
