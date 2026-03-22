/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/clef-sign/
enum ClefSign { G, F, C, percussion, TAB, jianpu, none }

ClefSign parseClefSign(String str) {
  switch (str) {
    case 'G':
      return ClefSign.G;
    case 'F':
      return ClefSign.F;
    case 'C':
      return ClefSign.C;
    case 'percussion':
      return ClefSign.percussion;
    case 'TAB':
      return ClefSign.TAB;
    case 'jianpu':
      return ClefSign.jianpu;
    case 'none':
      return ClefSign.none;
    default:
      throw FormatException('Unknown clef sign: $str');
  }
}
