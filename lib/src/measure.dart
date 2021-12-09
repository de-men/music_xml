import 'package:xml/xml.dart';

import 'chord_symbol.dart';
import 'key_signature.dart';
import 'music_xml_parser_state.dart';
import 'note.dart';
import 'note_duration.dart';
import 'tempo.dart';
import 'time_signature.dart';

/// Internal represention of the MusicXML <measure> element.
class Measure {
  final notes = <Note>[];
  final chordSymbols = <ChordSymbol>[];
  final tempos = <Tempo>[];
  TimeSignature? timeSignature;
  KeySignature? keySignature;
  int duration = 0;

  Measure._();

  /// Parse the <measure> element.
  factory Measure.parse(XmlElement xmlMeasure, MusicXMLParserState state) {
    final startTimePosition = state.timePosition;
    return Measure._()
      // Cumulative duration in MusicXML duration.
      // Used for time signature calculations
      // Record the starting time of this measure so that time signatures
      // can be inserted at the beginning of the measure
      .._parse(xmlMeasure, state)
      // Update the time signature if a partial or pickup measure
      .._fixTimeSignature(state, startTimePosition);
  }

  void _parse(XmlElement xmlMeasure, MusicXMLParserState state) {
    for (final child in xmlMeasure.childElements) {
      switch (child.name.local) {
        case 'attributes':
          _parseAttributes(child, state);
          break;
        case 'backup':
          _parseBackup(child, state);
          break;
        case 'direction':
          _parseDirection(child, state);
          break;
        case 'forward':
          _parseForward(child, state);
          break;
        case 'note':
          final note = Note.parse(child, state);
          notes.add(note);
          // Keep track of current note as previous note for chord timings
          state.previousNote = note;

          // Sum up the MusicXML durations in voice 1 of this measure
          if (note.voice == 1 && !note.isInChord) {
            duration += note.noteDuration.duration ?? 0;
          }
          break;
        case 'harmony':
          final chordSymbol = ChordSymbol.parse(child, state);
          chordSymbols.add(chordSymbol);
          break;
        default:
        // Ignore other tag types because they are not relevant to Magenta.
      }
    }
  }

  /// Parse the MusicXML <attributes> element.
  void _parseAttributes(XmlElement xmlAttributes, MusicXMLParserState state) {
    for (final child in xmlAttributes.childElements) {
      switch (child.name.local) {
        case 'divisions':
          state.divisions = int.parse(child.text);
          break;
        case 'key':
          keySignature = KeySignature.parse(state, child);
          break;
        case 'time':
          if (timeSignature == null) {
            timeSignature = TimeSignature.parse(state, child);
            state.timeSignature = timeSignature;
          } else {
            throw Exception('Multiple time signatures');
          }
          break;
        case 'transpose':
          final transpose = int.parse(child.getElement('chromatic')!.text);
          state.transpose = transpose;
          if (keySignature != null) {
            // Transposition is chromatic. Every half step up is 5 steps backward
            // on the circle of fifths, which has 12 positions.
            final keyTranspose = (transpose * -5) % 12;
            var newKey = keySignature!.key + keyTranspose;
            // If the new key has >6 sharps, translate to flats.
            // TODO(fjord): Could be more smart about when to use sharps vs. flats
            // when there are enharmonic equivalents.
            if (newKey > 6) newKey %= -6;
            keySignature!.key = newKey;
          }
          break;
        default:
        // Ignore other tag types because they are not relevant to Magenta.
      }
    }
  }

  /// Parse the MusicXML <backup> element.
  ///
  /// This moves the global time position backwards.
  ///
  /// Args:
  ///   xml_backup: XML element with tag type 'backup'.
  void _parseBackup(XmlElement xmlBackup, MusicXMLParserState state) {
    final xmlDuration = xmlBackup.getElement('duration');
    final backupDuration = int.parse(xmlDuration!.text);
    final midiTicks = backupDuration * standardPpq / state.divisions;
    final seconds = midiTicks / standardPpq * state.secondsPerQuarter;
    state.timePosition -= seconds;
  }

  /// Parse the MusicXML <direction> element.
  void _parseDirection(XmlElement xmlDirection, MusicXMLParserState state) {
    for (final child in xmlDirection.childElements) {
      if (child.name.local == 'sound') {
        if (child.getElement('tempo') != null) {
          final tempo = Tempo.parse(child, state);
          tempos.add(tempo);
          state.qpm = tempo.qpm;
          state.secondsPerQuarter = 60 / state.qpm;
          final dynamics = child.getAttribute('dynamics');
          if (dynamics != null) {
            state.velocity = int.parse(dynamics);
          }
        }
      }
    }
  }

  /// Parse the MusicXML <forward> element.
  ///
  /// This moves the global time position forward.
  ///
  /// Args:
  ///   xml_forward: XML element with tag type 'forward'.
  void _parseForward(XmlElement xmlForward, MusicXMLParserState state) {
    final xmlDuration = xmlForward.getElement('duration');
    final forwardDuration = int.parse(xmlDuration!.text);
    final midiTicks = forwardDuration * standardPpq / state.divisions;
    final seconds = midiTicks / standardPpq * state.secondsPerQuarter;
    state.timePosition += seconds;
  }

  /// Correct the time signature for incomplete measures.
  /// If the measure is incomplete or a pickup, insert an appropriate
  /// time signature into this Measure.
  void _fixTimeSignature(MusicXMLParserState state, double startTimePosition) {
    // Compute the fractional time signature (duration / divisions)
    // Multiply divisions by 4 because division is always parts per quarter note
    final numerator = duration;
    final denominator = state.divisions * 4;
    final fractionalTimeSignature = numerator / denominator;

    if (state.timeSignature == null && timeSignature == null) {
      // No global time signature yet and no measure time signature defined
      // in this measure (no time signature or senza misura).
      // Insert the fractional time signature as the time signature
      // for this measure
      timeSignature = TimeSignature.parse(state);
      timeSignature!.numerator = numerator;
      timeSignature!.denominator = denominator;
      state.timeSignature = timeSignature;
    } else {
      final fractionalStateTimeSignature =
          state.timeSignature!.numerator / state.timeSignature!.denominator;

      // Check for pickup measure. Reset time signature to smaller numerator
      final pickupMeasure = numerator < state.timeSignature!.numerator;

      // Get the current time signature denominator
      final globalTimeSignatureDenominator = state.timeSignature!.denominator;

      // If the fractional time signature = 1 (e.g. 4/4),
      // make the numerator the same as the global denominator
      TimeSignature newTimeSignature = TimeSignature.parse(state);
      if (fractionalTimeSignature.toDouble() == 1 && !pickupMeasure) {
        newTimeSignature.numerator = globalTimeSignatureDenominator;
        newTimeSignature.denominator = globalTimeSignatureDenominator;
      } else {
        // # Otherwise, set the time signature to the fractional time signature
        // # Issue #674 - Use the original numerator and denominator
        // # instead of the fractional one
        newTimeSignature = TimeSignature.parse(state);
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
        state.timeSignature = newTimeSignature;
      }
    }
  }
}
