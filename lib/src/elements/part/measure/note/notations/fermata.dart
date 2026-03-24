import 'package:xml/xml.dart';

import '../../../../../attributes/token_attribute.dart';
import '../../../../../data_types/fermata_shape.dart';
import '../../../../../data_types/upright_inverted.dart';
import '../../../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/fermata/
class Fermata extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, font-family,
  //       font-size, font-style, font-weight, id, relative-x, relative-y
  final FermataShape fermataShape;
  final UprightInverted? fermataType;

  factory Fermata.parse(XmlElement element) {
    final typeAttr = element.getAttribute(Local.type);
    return Fermata(
      fermataShape: parseFermataShape(element.innerText),
      fermataType: typeAttr != null ? parseUprightInverted(typeAttr) : null,
    );
  }

  Fermata({required this.fermataShape, this.fermataType})
      : super.tag(
          Local.fermata,
          attributes: [
            if (fermataType != null)
              TokenAttr(Local.type, uprightInvertedToString[fermataType]!),
          ],
          children: [XmlText(fermataShapeToString[fermataShape]!)],
        );
}
