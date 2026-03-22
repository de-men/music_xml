import 'package:xml/xml.dart';

import '../../../../../local.dart';
import 'chromatic.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/transpose/
class Transpose extends XmlElement {
  // TODO: support <diatonic> (Optional)
  final Chromatic chromatic;
  // TODO: support <octave-change> (Optional)
  // TODO: support <double> (Optional)

  factory Transpose.parse(XmlElement element) {
    late final Chromatic chromatic;

    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.chromatic:
          chromatic = Chromatic.parse(child);
          break;
      }
    }

    return Transpose(chromatic);
  }

  Transpose(this.chromatic) : super.tag(Local.transpose, children: [chromatic]);
}
