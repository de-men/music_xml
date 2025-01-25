import 'package:xml/xml.dart';

import '../../../../../local.dart';

final yes = 'yes';
final no = 'no';

class Slash extends XmlAttribute {
  final bool yesNo;

  factory Slash.parse(XmlAttribute attribute) {
    return Slash((attribute.value == yes));
  }

  Slash(this.yesNo)
      : super(
          XmlName(Local.makeTime),
          '${yesNo ? yes : no}',
        );
}
