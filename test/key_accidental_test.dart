import 'package:music_xml/src/element/part/measure/attributes/key/key_accidental.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  test('parses known accidental values', () {
    final sharp = KeyAccidental.parse(
      XmlDocument.parse('<key-accidental>sharp</key-accidental>').rootElement,
    );
    expect(sharp.accidentalValue, AccidentalValue.sharp);

    final flat = KeyAccidental.parse(
      XmlDocument.parse('<key-accidental>flat</key-accidental>').rootElement,
    );
    expect(flat.accidentalValue, AccidentalValue.flat);

    final natural = KeyAccidental.parse(
      XmlDocument.parse('<key-accidental>natural</key-accidental>').rootElement,
    );
    expect(natural.accidentalValue, AccidentalValue.natural);
  });

  test('falls back to other for unrecognized accidental values', () {
    final unknown = KeyAccidental.parse(
      XmlDocument.parse('<key-accidental>unknown-value</key-accidental>')
          .rootElement,
    );
    expect(unknown.accidentalValue, AccidentalValue.other);
  });
}
