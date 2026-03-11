import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/element/part/measure/attributes/divisions.dart';
import 'package:xml/xml.dart';

import '../../../../local.dart';
import 'clef/clef.dart';
import 'key/fifths.dart';
import 'transpose/transpose.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/attributes/
class Attributes extends XmlElement {
  final Divisions? divisions;

  // Zero or more times
  final Iterable<Key> keys;

  // Zero or more times
  final Iterable<Time> times;

  // Zero or more times
  final Iterable<Clef> clefs;

  // Zero or one time
  final Iterable<Transpose> transposes;

  factory Attributes.parse(
    MusicXMLParserState state,
    XmlElement element,
    Iterable<Time> times,
  ) {
    Divisions? divisions;
    final keys = <Key>[];
    final times = <Time>[];
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
          transposes.add(Transpose.parse(child));
          state.transpose = transpose.chromatic.semitones;
          if (keys.isNotEmpty) {
            // Transposition is chromatic. Every half step up is 5 steps backward
            // on the circle of fifths, which has 12 positions.
            final keyTranspose = (state.transpose * -5) % 12;

            var newKey = keys.last.key + keyTranspose;
            // If the new key has >6 sharps, translate to flats.
            // TODO(fjord): Could be more smart about when to use sharps vs. flats
            // when there are enharmonic equivalents.
            if (newKey > 6) newKey %= -6;
            keys.removeLast();
            keys.add(Key(fifths: Fifths(newKey)));
          }
          break;
        default:
        // Ignore other tag types because they are not relevant to Magenta.
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
  }) : super(XmlName(Local.attributes), [], [
          if (divisions != null) divisions,
          ...keys,
          ...times,
          ...clefs,
          ...transposes,
        ]);
}
