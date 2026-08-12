/// An XML name token: one or more name characters and no whitespace.
///
/// Unlike an XML `Name`, an `NMTOKEN` may start with a digit, a dot or a
/// hyphen, so `1`, `verse1` and `-a` are all valid.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/xsd-NMTOKEN/
class NmToken {
  final String value;

  NmToken(this.value) : assert(isValid(value), '"$value" is not an NMTOKEN');

  factory NmToken.parse(String text) => NmToken(text);

  /// `Nmtoken ::= (NameChar)+` from the XML 1.0 specification.
  /// Characters above the basic plane are not checked.
  static final _nameChars = RegExp(
    r'^[-.0-9:_A-Za-z\u00b7\u00c0-\u00d6\u00d8-\u00f6\u00f8-\u037d'
    r'\u037f-\u1fff\u200c-\u200d\u203f-\u2040\u2070-\u218f\u2c00-\u2fef'
    r'\u3001-\ud7ff\uf900-\ufdcf\ufdf0-\ufffd]+$',
  );

  static bool isValid(String value) => _nameChars.hasMatch(value);

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) => other is NmToken && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
