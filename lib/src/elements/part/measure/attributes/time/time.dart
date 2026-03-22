import 'package:xml/xml.dart';

import '../../../../../local.dart';
import '../../../../../music_xml_parser_state.dart';
import 'beat_type.dart';
import 'beats.dart';

/// Internal representation of a MusicXML time signature.
/// Does not support:
/// - Composite time signatures: 3+2/8
/// - Alternating time signatures 2/4 + 3/8
///
/// TODO: support `<interchangeable>` (optional, after each beats/beat-type pair)
/// TODO: support `<senza-misura>` (alternative to beats/beat-type)
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/time/
class Time extends XmlElement {
  /// In this order (One or more times)
  /// `<beats>` (Required)
  /// `<beat-type>` (Required)
  /// `<interchangeable>` (Optional) — not yet supported
  final Iterable<BeatsBeatType> beatsBeatTypes;

  int numerator;
  int denominator;
  int divisions;
  double timePosition;

  int get beatsPerMeasure => numerator ~/ divisions;

  int get beatUnit => denominator ~/ divisions;

  /// Parse the MusicXML `<time>` element.
  factory Time.parse(MusicXMLParserState state, [XmlElement? element]) {
    int numerator = -1;
    int denominator = -1;

    double timePosition = 0;

    final beatsBeatTypes = <BeatsBeatType>[];
    Beats? beats;

    element?.childElements.forEach((e) {
      switch (e.name.local) {
        case Local.beats:
          if (beatsBeatTypes.isNotEmpty) {
            // If more than 1 beats or beat-type found, this time signature is
            // not supported (ex: alternating meter)
            throw Exception('Alternating Time Signature');
          }
          beats = Beats.parse(e);
          break;
        case Local.beatType:
          beatsBeatTypes.add(
            BeatsBeatType(beats: beats!, beatType: BeatType.parse(e)),
          );
          break;
      }
    });

    if (beatsBeatTypes.length == 1) {
      final b = beatsBeatTypes.single.beats;
      final bt = beatsBeatTypes.single.beatType;
      try {
        numerator = int.parse(b.content);
        denominator = int.parse(bt.content);
      } catch (e) {
        throw Exception('Could not parse time signature: $b/$bt');
      }

      timePosition = state.timePosition;
    }

    return Time(
      beatsBeatTypes: beatsBeatTypes,
      divisions: state.divisions,
      numerator: numerator,
      denominator: denominator,
      timePosition: timePosition,
    );
  }

  Time({
    required this.beatsBeatTypes,
    required this.divisions,
    this.numerator = -1,
    this.denominator = -1,
    this.timePosition = 0,
  }) : super.tag(
          Local.time,
          children: [
            ...beatsBeatTypes.expand((e) => [e.beats, e.beatType]),
          ],
        );
}

class BeatsBeatType {
  final Beats beats;
  final BeatType beatType;

  BeatsBeatType({required this.beats, required this.beatType});
}
