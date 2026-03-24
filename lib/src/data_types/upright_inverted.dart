/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/upright-inverted/
enum UprightInverted {
  upright,
  inverted,
}

const _uprightInvertedMap = {
  'upright': UprightInverted.upright,
  'inverted': UprightInverted.inverted,
};

UprightInverted parseUprightInverted(String str) =>
    _uprightInvertedMap[str] ?? UprightInverted.upright;

const uprightInvertedToString = {
  UprightInverted.upright: 'upright',
  UprightInverted.inverted: 'inverted',
};
