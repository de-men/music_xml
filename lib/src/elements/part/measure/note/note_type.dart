import 'package:xml/xml.dart';

import '../../../../data_types/note_type_value.dart';
import '../../../../data_types/symbol_size.dart';
import '../../../../local.dart';

/// The MusicXML `<type>` element inside a `<note>`.
/// It holds the graphic note type, such as `whole`, `half`, or `quarter`.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/type/
class NoteType extends XmlElement {
  /// The raw text value, kept as-is so any value round-trips (even
  /// non-standard ones some exporters write, like `dotted-half`).
  final String content;

  /// The `size` attribute (symbol-size), or null when it was missing.
  final SymbolSize? size;

  /// The typed note type value, or null when [content] is not a standard
  /// MusicXML note type.
  NoteTypeValue? get noteTypeValue => parseNoteTypeValue(content);

  factory NoteType.parse(XmlElement element) {
    final sizeAttr = element.getAttribute(Local.size);
    return NoteType(
      element.innerText,
      size: sizeAttr != null ? parseSymbolSize(sizeAttr) : null,
    );
  }

  NoteType(this.content, {this.size})
      : super.tag(
          Local.type,
          attributes: [
            if (size != null) SymbolSizeAttr(size),
          ],
          children: [XmlText(content)],
        );

  /// Builds a `<type>` from a typed value.
  NoteType.of(NoteTypeValue value, {SymbolSize? size})
      : this(noteTypeValueToString[value]!, size: size);
}
