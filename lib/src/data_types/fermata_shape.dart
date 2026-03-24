/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/fermata-shape/
enum FermataShape {
  normal,
  angled,
  square,
  doubleAngled,
  doubleSquare,
  doubleDot,
  halfCurve,
  curlew,
  emptyValue,
}

const _fermataShapeMap = {
  'normal': FermataShape.normal,
  'angled': FermataShape.angled,
  'square': FermataShape.square,
  'double-angled': FermataShape.doubleAngled,
  'double-square': FermataShape.doubleSquare,
  'double-dot': FermataShape.doubleDot,
  'half-curve': FermataShape.halfCurve,
  'curlew': FermataShape.curlew,
  '': FermataShape.emptyValue,
};

FermataShape parseFermataShape(String str) =>
    _fermataShapeMap[str] ?? FermataShape.normal;

const fermataShapeToString = {
  FermataShape.normal: 'normal',
  FermataShape.angled: 'angled',
  FermataShape.square: 'square',
  FermataShape.doubleAngled: 'double-angled',
  FermataShape.doubleSquare: 'double-square',
  FermataShape.doubleDot: 'double-dot',
  FermataShape.halfCurve: 'half-curve',
  FermataShape.curlew: 'curlew',
  FermataShape.emptyValue: '',
};
