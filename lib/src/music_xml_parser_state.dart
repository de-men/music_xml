import 'note.dart';
import 'time_signature.dart';

/// Default MIDI Program (0 = grand piano)
const defaultMidiChannel = 0;

/// Default MIDI Channel (0 = first channel)
const defaultMidiProgram = 0;

/// Maintains internal state of the MusicXML parser.
class MusicXMLParserState {
  // Default to one division per measure
  // From the MusicXML documentation: "The divisions element indicates
  // how many divisions per quarter note are used to indicate a note's
  // duration. For example, if duration = 1 and divisions = 2,
  // this is an eighth note duration."
  var divisions = 1;

  // Default to a tempo of 120 quarter notes per minute
  // MusicXML calls this tempo, but Magenta calls this qpm
  // Therefore, the variable is called qpm, but reads the
  // MusicXML tempo attribute
  // (120 qpm is the default tempo according to the
  // Standard MIDI Files 1.0 Specification)
  var qpm = 120.0;

  // Duration of a single quarter note in seconds
  var secondsPerQuarter = 0.5;

  // Running total of time for the current event in seconds.
  // Resets to 0 on every part. Affected by <forward> and <backup> elements
  var timePosition = 0.0;

  // Default to a MIDI velocity of 64 (mf)
  var velocity = 64;

  // Default MIDI program (0 = grand piano)
  var midiProgram = defaultMidiProgram;

  // Current MIDI channel (usually equal to the part number)
  var midiChannel = defaultMidiChannel;

  // Keep track of previous note to get chord timing correct
  // This variable stores an instance of the Note class (defined below)
  Note? previousNote;

  // Keep track of current transposition level in +/- semitones.
  var transpose = 0;

  // Keep track of current time signature. Does not support polymeter.
  TimeSignature? timeSignature;
}
