import 'package:music_xml/music_xml.dart';
import '../../../../music_xml_parser_state.dart';
import 'package:music_xml/src/elements/part/measure/attributes/divisions.dart';
import 'package:xml/xml.dart';

import '../../../../local.dart';
import 'clef/clef.dart';
import 'key/fifths.dart';
import 'transpose/transpose.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/attributes/
class Attributes extends XmlElement {
  // TODO: support <footnote>, <level> (editorial group)
  final Divisions? divisions;
  final Iterable<Key> keys;
  final Iterable<Time> times;
  // TODO: support <staves>, <part-symbol>, <instruments>
  final Iterable<Clef> clefs;
  // TODO: support <staff-details> (Zero or more times)
  final Iterable<Transpose> transposes;
  // TODO: support <for-part>, <directive>, <measure-style>

  factory Attributes.parse(
    MusicXMLParserState state,
    XmlElement element,
    List<Time> times,
  ) {
    Divisions? divisions;
    final keys = <Key>[];
    final clefs = <Clef>[];
    final transposes = <Transpose>[];
    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.divisions:
          state.divisions = int.parse(child.innerText);
          divisions = Divisions.parse(child);
          break;
        case Local.key:
          keys.add(Key.parse(state, child));
          break;
        case Local.time:
          if (times.isEmpty) {
            times.add(Time.parse(state, child));
            state.time = times.single;
          } else {
            throw Exception('Multiple time signatures');
          }
          break;
        case Local.clef:
          clefs.add(Clef.parse(child));
          break;
        case Local.transpose:
          final transpose = Transpose.parse(child);
          transposes.add(transpose);
          state.transpose = transpose.chromatic.semitones;
          if (keys.isNotEmpty) {
            // Transposition is chromatic. Every half step up is 5 steps
            // backward on the circle of fifths, which has 12 positions.
            final keyTranspose = (state.transpose * -5) % 12;
            var newKey = keys.last.key + keyTranspose;
            // If the new key has >6 sharps, translate to flats.
            // TODO: be smarter about when to use sharps vs. flats
            // for enharmonic equivalents.
            if (newKey > 6) newKey %= -6;
            keys.removeLast();
            keys.add(Key(fifths: Fifths(newKey)));
          }
          break;
        default:
          // TODO: support remaining <attributes> child elements
          break;
      }
    }
    return Attributes(
      divisions: divisions,
      keys: keys,
      times: times,
      clefs: clefs,
      transposes: transposes,
    );
  }

  Attributes({
    this.divisions,
    this.keys = const [],
    this.times = const [],
    this.clefs = const [],
    this.transposes = const [],
  }) : super.tag(
          Local.attributes,
          children: [
            if (divisions != null) divisions,
            ...keys,
            ...times,
            ...clefs,
            ...transposes,
          ],
        );
}
