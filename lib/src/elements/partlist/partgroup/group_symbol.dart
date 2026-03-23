import 'package:xml/xml.dart';

import '../../../data_types/group_symbol_value.dart';
import '../../../local.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/group-symbol/
class GroupSymbol extends XmlElement {
  // TODO: support attributes: color, default-x, default-y, relative-x,
  //       relative-y
  final GroupSymbolValue groupSymbolValue;

  factory GroupSymbol.parse(XmlElement element) {
    return GroupSymbol(parseGroupSymbolValue(element.innerText));
  }

  GroupSymbol(this.groupSymbolValue)
      : super.tag(
          Local.groupSymbol,
          children: [XmlText(groupSymbolValueToString[groupSymbolValue]!)],
        );
}
