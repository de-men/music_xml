import 'package:music_xml/src/element/part/measure/barline.dart';
import 'package:music_xml/src/element/part/measure/backup.dart';
import 'package:music_xml/src/element/part/measure/direction/direction.dart';
import 'package:music_xml/src/element/part/measure/print.dart';
import 'package:xml/xml.dart';

import 'chord_symbol.dart';
import '../../../local.dart';
import '../../../music_xml_parser_state.dart';
import 'attributes/attributes.dart';
import 'forward.dart';
import 'note/note.dart';
import 'direction/sound/tempo.dart';
import 'attributes/time/time.dart';
import 'number.dart';

/// Internal represention of the MusicXML <measure> element.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/measure-partwise/
class Measure extends XmlElement {
  // Attributes
  Number number;

  // Elements
  final List<Note> notes;
  final Iterable<Backup> backups;
  final Iterable<Forward> forwards;
  final Iterable<Direction> directions;

  final Iterable<Attributes> attributesList;
  final Iterable<ChordSymbol> chordSymbols;
  final Iterable<Print> prints;
  final Iterable<Barline> barlines;

  // Extends
  final Iterable<Tempo> tempos;
  final int duration;

  /// Parse the <measure> element.
  factory Measure.parse(MusicXMLParserState state, XmlElement element) {
    final startTimePosition = state.timePosition;

    final numberAttribute = element.getAttribute(Local.number)!;

    final notes = <Note>[];
    int duration = 0;
    final backups = <Backup>[];
    final forwards = <Forward>[];
    final directions = <Direction>[];

    final attributesList = <Attributes>[];
    final times = <Time>[];

    final chordSymbols = <ChordSymbol>[];
    final prints = <Print>[];
    final barlines = <Barline>[];

    // extends
    final tempos = <Tempo>[];

    // Cumulative duration in MusicXML duration.
    // Used for time signature calculations
    // Record the starting time of this measure so that time signatures
    // can be inserted at the beginning of the measure
    for (final child in element.childElements) {
      switch (child.name.local) {
        case Local.note:
          final note = Note.parse(child, state);
          notes.add(note);
          // Keep track of current note as previous note for chord timings
          state.previousNote = note;

          // Sum up the MusicXML durations in voice 1 of this measure
          if (note.voice == 1 && !note.isInChord) {
            duration += note.noteDuration.duration;
          }
          break;
        case Local.backup:
          backups.add(Backup.parse(state, child));
          break;
        case Local.forward:
          forwards.add(Forward.parse(state, child));
          break;
        case Local.direction:
          final direction = Direction.parse(state, child);
          directions.add(direction);
          final tempo = direction.sound?.tempo;
          if (tempo != null) {
            tempos.add(tempo);
            state.qpm = tempo.qpm;
            state.secondsPerQuarter = 60 / state.qpm;
            if (direction.sound?.dynamics != null) {
              state.velocity =
                  direction.sound!.dynamics!.nonNegativeDecimal as int;
            }
          }
          break;
        case Local.attributes:
          attributesList.add(Attributes.parse(state, child, times));
          break;
        case Local.harmony:
          chordSymbols.add(ChordSymbol.parse(child, state));
          break;
        case 'print':
          prints.add(Print.parse(child, state));
          break;
        case 'barline':
          barlines.add(Barline.parse(child, state));
          break;
        default:
        // Ignore other tag types because they are not relevant to Magenta.
      }
    }

    // Update the time signature if a partial or pickup measure
    _fixTimeSignature(
      state,
      startTimePosition,
      duration,
      times.isEmpty ? null : times.first,
    );

    return Measure(
      number: Number(numberAttribute),
      notes: notes,
      backups: backups,
      forwards: forwards,
      directions: directions,
      attributesList: attributesList,
      chordSymbols: chordSymbols,
      prints: prints,
      barlines: barlines,
      tempos: tempos,
      duration: duration,
    );
  }

  Measure({
    required this.number,
    this.notes = const [],
    this.backups = const [],
    this.forwards = const [],
    this.directions = const [],
    this.attributesList = const [],
    this.chordSymbols = const [],
    this.prints = const [],
    this.barlines = const [],
    this.tempos = const [],
    this.duration = 0,
  }) : super(
          XmlName(Local.measure),
          [number],
          [
            ...notes,
            ...backups,
            ...forwards,
            ...attributesList,
            ...chordSymbols,
            ...prints,
            ...barlines,
          ],
        );

  /// Correct the time signature for incomplete measures.
  /// If the measure is incomplete or a pickup, insert an appropriate
  /// time signature into this Measure.
  static Time? _fixTimeSignature(
    MusicXMLParserState state,
    double startTimePosition,
    int duration,
    Time? timeSignature,
  ) {
    // Compute the fractional time signature (duration / divisions)
    // Multiply divisions by 4 because division is always parts per quarter note
    final numerator = duration;
    final denominator = state.divisions * 4;
    final fractionalTimeSignature = numerator / denominator;

    Time? result = timeSignature;
    if (state.time == null && timeSignature == null) {
      // No global time signature yet and no measure time signature defined
      // in this measure (no time signature or senza misura).
      // Insert the fractional time signature as the time signature
      // for this measure
      timeSignature = Time.parse(state);
      timeSignature.numerator = numerator;
      timeSignature.denominator = denominator;
      state.time = timeSignature;
      result = timeSignature;
    } else {
      final fractionalStateTimeSignature =
          state.time!.numerator / state.time!.denominator;

      // Check for pickup measure. Reset time signature to smaller numerator
      final pickupMeasure = numerator < state.time!.numerator;

      // Get the current time signature denominator
      final globalTimeSignatureDenominator = state.time!.denominator;

      // If the fractional time signature = 1 (e.g. 4/4),
      // make the numerator the same as the global denominator
      Time newTimeSignature = Time.parse(state);
      if (fractionalTimeSignature.toDouble() == 1 && !pickupMeasure) {
        newTimeSignature.numerator = globalTimeSignatureDenominator;
        newTimeSignature.denominator = globalTimeSignatureDenominator;
      } else {
        // # Otherwise, set the time signature to the fractional time signature
        // # Issue #674 - Use the original numerator and denominator
        // # instead of the fractional one
        newTimeSignature = Time.parse(state);
        newTimeSignature.numerator = numerator;
        newTimeSignature.denominator = denominator;

        final newTimeSigFraction = numerator / denominator;
        if (newTimeSigFraction == fractionalTimeSignature) {
          newTimeSignature.numerator = numerator;
          newTimeSignature.denominator = denominator;
        }
      }

      // Insert a new time signature only if it does not equal the global
      // time signature.
      if (pickupMeasure ||
          (fractionalTimeSignature != fractionalStateTimeSignature)) {
        newTimeSignature.timePosition = startTimePosition;
        timeSignature = newTimeSignature;
        state.time = newTimeSignature;
        result = newTimeSignature;
      }
    }
    return result;
  }
}
