import 'music_xml_parser_state.dart';

/// Standard pulses per quarter.
/// https://en.wikipedia.org/wiki/Pulses_per_quarter_note
const standardPpq = 220;

class NoteDuration {
  /// MusicXML duration
  int? duration;

  /// Duration in MIDI ticks
  double? midiTicks;

  /// Duration in seconds
  double? seconds;

  /// Onset time in seconds
  double? timePosition;

  /// Number of augmentation dots
  int dots = 0;

  /// MusicXML duration type
  String type = 'quarter';

  /// Ratio for tuplets (default to 1)
  double tupletRatio = 1.0;

  bool isGraceNote = true;

  late final MusicXMLParserState _state;

  NoteDuration(MusicXMLParserState state) {
    _state = state;
  }

  /// Parse the duration of a note and compute timings.
  void parseDuration(bool isInChord, bool isGraceNote, String duration) {
    this.duration = int.parse(duration);

    // Due to an error in Sibelius' export, force this note to have the
    // duration of the previous note if it is in a chord
    if (isInChord) {
      this.duration = _state.previousNote?.noteDuration.duration;
    }

    midiTicks = this.duration?.toDouble() ?? 0.0;
    midiTicks = midiTicks! * (standardPpq / _state.divisions);

    seconds = midiTicks! / standardPpq;
    seconds = seconds! * _state.secondsPerQuarter;

    timePosition = _state.timePosition;

    // Not sure how to handle durations of grace notes yet as they
    // steal time from subsequent notes and they do not have a
    // <duration> tag in the MusicXML
    this.isGraceNote = isGraceNote;

    if (isInChord) {
      // If this is a chord, set the time position to the time position
      // of the previous note (i.e. all the notes in the chord will have
      // the same time position)
      timePosition = _state.previousNote?.noteDuration.timePosition;
    } else {
      // Only increment time positions once in chord
      _state.timePosition += seconds!;
    }
  }
}
