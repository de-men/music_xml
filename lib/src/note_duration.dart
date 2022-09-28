import 'music_xml_parser_state.dart';

/// Standard pulses per quarter.
/// https://en.wikipedia.org/wiki/Pulses_per_quarter_note
const standardPpq = 220;

class NoteDuration {
  /// MusicXML duration
  int duration;

  /// Duration in MIDI ticks
  double midiTicks;

  /// Duration in seconds
  double seconds;

  /// Onset time in seconds
  double timePosition;

  /// Number of augmentation dots
  int dots = 0;

  /// MusicXML duration type
  String type;

  /// Ratio for tuplets (default to 1)
  double tupletRatio;

  bool isGraceNote;

  NoteDuration(
    this.duration,
    this.midiTicks,
    this.seconds,
    this.timePosition,
    this.dots,
    this.type,
    this.tupletRatio,
    this.isGraceNote,
  );

  /// Parse the duration of a note and compute timings.
  factory NoteDuration.parse(
    bool isInChord,
    bool isGraceNote,
    String? durationText,
    int dots,
    String? type,
    double? tupletRatio,
    MusicXMLParserState state,
  ) {
    durationText ??= '0';
    int duration = int.parse(durationText);
    double? midiTicks;
    double seconds;
    double timePosition;
    bool? _isGraceNote;

    // Due to an error in Sibelius' export, force this note to have the
    // duration of the previous note if it is in a chord
    if (isInChord) {
      duration = state.previousNote?.noteDuration.duration ?? 1;
    }

    midiTicks = duration.toDouble();
    midiTicks = midiTicks * (standardPpq / state.divisions);

    seconds = midiTicks / standardPpq;
    seconds = seconds * state.secondsPerQuarter;

    timePosition = state.timePosition;

    // Not sure how to handle durations of grace notes yet as they
    // steal time from subsequent notes and they do not have a
    // <duration> tag in the MusicXML
    _isGraceNote = isGraceNote;

    if (isInChord) {
      // If this is a chord, set the time position to the time position
      // of the previous note (i.e. all the notes in the chord will have
      // the same time position)
      timePosition =
          state.previousNote?.noteDuration.timePosition ?? timePosition;
    } else {
      // Only increment time positions once in chord
      state.timePosition += seconds;
    }

    return NoteDuration(
      duration,
      midiTicks,
      seconds,
      timePosition,
      dots,
      type ?? 'quarter',
      tupletRatio ?? 1.0,
      _isGraceNote,
    );
  }
}
