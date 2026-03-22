import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/enclosure-shape/
enum EnclosureShape {
  rectangle,
  square,
  oval,
  circle,
  bracket,
  invertedBracket,
  triangle,
  diamond,
  pentagon,
  hexagon,
  heptagon,
  octagon,
  nonagon,
  decagon,
  none,
}

const _enclosureShapeMap = {
  'rectangle': EnclosureShape.rectangle,
  'square': EnclosureShape.square,
  'oval': EnclosureShape.oval,
  'circle': EnclosureShape.circle,
  'bracket': EnclosureShape.bracket,
  'inverted-bracket': EnclosureShape.invertedBracket,
  'triangle': EnclosureShape.triangle,
  'diamond': EnclosureShape.diamond,
  'pentagon': EnclosureShape.pentagon,
  'hexagon': EnclosureShape.hexagon,
  'heptagon': EnclosureShape.heptagon,
  'octagon': EnclosureShape.octagon,
  'nonagon': EnclosureShape.nonagon,
  'decagon': EnclosureShape.decagon,
  'none': EnclosureShape.none,
};

EnclosureShape? parseEnclosureShape(String? str) =>
    str != null ? _enclosureShapeMap[str] : null;

class EnclosureShapeAttr extends XmlAttribute {
  final EnclosureShape enclosureShape;

  EnclosureShapeAttr(String name, this.enclosureShape)
      : super(XmlName(name), enclosureShapeToString[enclosureShape]!);
}

const enclosureShapeToString = {
  EnclosureShape.rectangle: 'rectangle',
  EnclosureShape.square: 'square',
  EnclosureShape.oval: 'oval',
  EnclosureShape.circle: 'circle',
  EnclosureShape.bracket: 'bracket',
  EnclosureShape.invertedBracket: 'inverted-bracket',
  EnclosureShape.triangle: 'triangle',
  EnclosureShape.diamond: 'diamond',
  EnclosureShape.pentagon: 'pentagon',
  EnclosureShape.hexagon: 'hexagon',
  EnclosureShape.heptagon: 'heptagon',
  EnclosureShape.octagon: 'octagon',
  EnclosureShape.nonagon: 'nonagon',
  EnclosureShape.decagon: 'decagon',
  EnclosureShape.none: 'none',
};
