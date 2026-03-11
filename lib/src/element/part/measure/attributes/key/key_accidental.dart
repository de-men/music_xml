import 'package:music_xml/src/local.dart';
import 'package:xml/xml.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/accidental-value/
enum AccidentalValue {
  sharp,
  natural,
  flat,
  doubleSharp,
  sharpSharp,
  flatFlat,
  naturalSharp,
  naturalFlat,
  quarterFlat,
  quarterSharp,
  threeQuartersFlat,
  threeQuartersSharp,
  sharpDown,
  sharpUp,
  naturalDown,
  naturalUp,
  flatDown,
  flatUp,
  doubleSharpDown,
  doubleSharpUp,
  flatFlatDown,
  flatFlatUp,
  arrowDown,
  arrowUp,
  tripleSharp,
  tripleFlat,
  slashQuarterSharp,
  slashSharp,
  slashFlat,
  doubleSlashFlat,
  sharp1,
  sharp2,
  sharp3,
  sharp5,
  flat1,
  flat2,
  flat3,
  flat4,
  sori,
  koron,
  other,
}

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/key-accidental/
class KeyAccidental extends XmlElement {
  final AccidentalValue accidentalValue;

  factory KeyAccidental.parse(XmlElement element) {
    late final AccidentalValue accidentalValue;
    switch (element.innerText) {
      case 'sharp':
        accidentalValue = AccidentalValue.sharp;
        break;
      case 'natural':
        accidentalValue = AccidentalValue.natural;
        break;
      case 'flat':
        accidentalValue = AccidentalValue.flat;
        break;
      case 'double-sharp':
        accidentalValue = AccidentalValue.doubleSharp;
        break;
      case 'sharp-sharp':
        accidentalValue = AccidentalValue.sharpSharp;
        break;
      case 'flat-flat':
        accidentalValue = AccidentalValue.flatFlat;
        break;
      case 'natural-sharp':
        accidentalValue = AccidentalValue.naturalSharp;
        break;
      case 'natural-flat':
        accidentalValue = AccidentalValue.naturalFlat;
        break;
      case 'quarter-flat':
        accidentalValue = AccidentalValue.quarterFlat;
        break;
      case 'quarter-sharp':
        accidentalValue = AccidentalValue.quarterSharp;
        break;
      case 'three-quarters-flat':
        accidentalValue = AccidentalValue.threeQuartersFlat;
        break;
      case 'three-quarters-sharp':
        accidentalValue = AccidentalValue.threeQuartersSharp;
        break;
      case 'sharp-down':
        accidentalValue = AccidentalValue.sharpDown;
        break;
      case 'sharp-up':
        accidentalValue = AccidentalValue.sharpUp;
        break;
      case 'natural-down':
        accidentalValue = AccidentalValue.naturalDown;
        break;
      case 'natural-up':
        accidentalValue = AccidentalValue.naturalUp;
        break;
      case 'flat-down':
        accidentalValue = AccidentalValue.flatDown;
        break;
      case 'flat-up':
        accidentalValue = AccidentalValue.flatUp;
        break;
      case 'double-sharp-down':
        accidentalValue = AccidentalValue.doubleSharpDown;
        break;
      case 'double-sharp-up':
        accidentalValue = AccidentalValue.doubleSharpUp;
        break;
      case 'flat-flat-down':
        accidentalValue = AccidentalValue.flatFlatDown;
        break;
      case 'flat-flat-up':
        accidentalValue = AccidentalValue.flatFlatUp;
        break;
      case 'arrow-down':
        accidentalValue = AccidentalValue.arrowDown;
        break;
      case 'arrow-up':
        accidentalValue = AccidentalValue.arrowUp;
        break;
      case 'triple-sharp':
        accidentalValue = AccidentalValue.tripleSharp;
        break;
      case 'triple-flat':
        accidentalValue = AccidentalValue.tripleFlat;
        break;
      case 'slash-quarter-sharp':
        accidentalValue = AccidentalValue.slashQuarterSharp;
        break;
      case 'slash-sharp':
        accidentalValue = AccidentalValue.slashSharp;
        break;
      case 'slash-flat':
        accidentalValue = AccidentalValue.slashFlat;
        break;
      case 'double-slash-flat':
        accidentalValue = AccidentalValue.doubleSlashFlat;
        break;
      case 'sharp-1':
        accidentalValue = AccidentalValue.sharp1;
        break;
      case 'sharp-2':
        accidentalValue = AccidentalValue.sharp2;
        break;
      case 'sharp-3':
        accidentalValue = AccidentalValue.sharp3;
        break;
      case 'sharp-5':
        accidentalValue = AccidentalValue.sharp5;
        break;
      case 'flat-1':
        accidentalValue = AccidentalValue.flat1;
        break;
      case 'flat-2':
        accidentalValue = AccidentalValue.flat2;
        break;
      case 'flat-3':
        accidentalValue = AccidentalValue.flat3;
        break;
      case 'flat-4':
        accidentalValue = AccidentalValue.flat4;
        break;
      case 'sori':
        accidentalValue = AccidentalValue.sori;
        break;
      case 'koron':
        accidentalValue = AccidentalValue.koron;
        break;
      case 'other':
        accidentalValue = AccidentalValue.other;
        break;
      default:
        accidentalValue = AccidentalValue.other;
        break;
    }

    return KeyAccidental(accidentalValue);
  }

  KeyAccidental(this.accidentalValue) : super(XmlName(Local.keyAccidental));
}
