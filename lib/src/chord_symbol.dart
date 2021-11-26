import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';
import 'note_duration.dart';

/// The below dictionary maps chord kinds to an abbreviated string as would
/// appear in a chord symbol in a standard lead sheet. There are often multiple
/// standard abbreviations for the same chord type, e.g. "+" and "aug" both
/// refer to an augmented chord, and "maj7", "M7", and a Delta character all
/// refer to a major-seventh chord; this dictionary attempts to be consistent
/// but the choice of abbreviation is somewhat arbitrary.
///
/// The MusicXML-defined chord kinds are listed here:
/// http://usermanuals.musicxml.com/MusicXML/Content/ST-MusicXML-kind-value.htm
const chordKindAbbreviations = <String, String>{
// These chord kinds are in the MusicXML spec.
  'major': '',
  'minor': 'm',
  'augmented': 'aug',
  'diminished': 'dim',
  'dominant': '7',
  'major-seventh': 'maj7',
  'minor-seventh': 'm7',
  'diminished-seventh': 'dim7',
  'augmented-seventh': 'aug7',
  'half-diminished': 'm7b5',
  'major-minor': 'm(maj7)',
  'major-sixth': '6',
  'minor-sixth': 'm6',
  'dominant-ninth': '9',
  'major-ninth': 'maj9',
  'minor-ninth': 'm9',
  'dominant-11th': '11',
  'major-11th': 'maj11',
  'minor-11th': 'm11',
  'dominant-13th': '13',
  'major-13th': 'maj13',
  'minor-13th': 'm13',
  'suspended-second': 'sus2',
  'suspended-fourth': 'sus',
  'pedal': 'ped',
  'power': '5',
  'none': 'N.C.',

// These are not in the spec, but show up frequently in the wild.
  'dominant-seventh': '7',
  'augmented-ninth': 'aug9',
  'minor-major': 'm(maj7)',

// Some abbreviated kinds also show up frequently in the wild.
  '': '',
  'min': 'm',
  'aug': 'aug',
  'dim': 'dim',
  '7': '7',
  'maj7': 'maj7',
  'min7': 'm7',
  'dim7': 'dim7',
  'm7b5': 'm7b5',
  'minMaj7': 'm(maj7)',
  '6': '6',
  'min6': 'm6',
  'maj69': '6(add9)',
  '9': '9',
  'maj9': 'maj9',
  'min9': 'm9',
  'sus47': 'sus7'
};

/// Internal representation of a MusicXML chord symbol <harmony> element.
/// This represents a chord symbol with four components:
/// 1) Root: a string representing the chord root pitch class, e.g. "C#".
/// 2) Kind: a string representing the chord kind, e.g. "m7" for minor-seventh,
///     "9" for dominant-ninth, or the empty string for major triad.
/// 3) Scale degree modifications: a list of strings representing scale degree
///     modifications for the chord, e.g. "add9" to add an unaltered ninth scale
///     degree (without the seventh), "b5" to flatten the fifth scale degree,
///     "no3" to remove the third scale degree, etc.
/// 4) Bass: a string representing the chord bass pitch class, or None if the bass
///     pitch class is the same as the root pitch class.
/// There's also a special chord kind "N.C." representing no harmony, for which
/// all other fields should be None.
/// Use the `get_figure_string` method to get a string representation of the chord
/// symbol as might appear in a lead sheet. This string representation is what we
/// use to represent chord symbols in NoteSequence protos, as text annotations.
/// While the MusicXML representation has more structure, using an unstructured
/// string provides more flexibility and allows us to ingest chords from other
/// sources, e.g. guitar tabs on the web.
class ChordSymbol {
  late final double timePosition;
  String? root;
  String? kind;
  final degrees = <String>[];
  String? bass;

  ChordSymbol(XmlElement xmlHarmony, MusicXMLParserState state) {
    timePosition = state.timePosition;

    for (final XmlElement child in xmlHarmony.childElements) {
      switch (child.name.local) {
        case 'root':
          _parseRoot(child, state);
          break;
        case 'kind':
          // Seems like this shouldn't happen but frequently does in the wild...
          final kindText = child.text.trim();
          if (!chordKindAbbreviations.containsKey(kindText)) {
            throw XmlParserException('Unknown chord kind: $kindText');
          }
          kind = chordKindAbbreviations[kindText];
          break;
        case 'degree':
          degrees.add(_parseDegree(child));
          break;
        case 'bass':
          _parseBass(child, state);
          break;
        case 'offset':
          // Offset tag moves chord symbol time position.
          try {
            final offset = int.parse(child.text);
            final midiTicks = offset * standardPpq / state.divisions;
            final seconds = midiTicks / standardPpq * state.secondsPerQuarter;
            timePosition += seconds;
          } catch (e) {
            throw XmlParserException('Non-integer offset: ${child.text}');
          }
          break;
        default:
        // Ignore other tag types because they are not relevant to Magenta.
      }
    }
    if (root == null && kind != 'N.C.') {
      throw XmlParserException('Chord symbol must have a root');
    }
  }

  /// Parse the <root> tag for a chord symbol.
  void _parseRoot(XmlElement child, MusicXMLParserState state) {
    root = _parsePitch(child, 'root-step', 'root-alter', state);
  }

  /// Parse the <bass> tag for a chord symbol.
  void _parseBass(XmlElement xmlBass, MusicXMLParserState state) {
    bass = _parsePitch(xmlBass, 'bass-step', 'bass-alter', state);
  }

  /// Parse and return the pitch-like <root> or <bass> element.
  String _parsePitch(
    XmlElement xmlPitch,
    String stepTag,
    String alterTag,
    MusicXMLParserState state,
  ) {
    final xmlStepTag = xmlPitch.getElement(stepTag);
    if (xmlStepTag == null) {
      throw XmlParserException('Missing pitch step');
    }
    final step = xmlStepTag.text;

    var alterString = '';
    final xmlAlterTag = xmlPitch.getElement(alterTag);
    if (xmlAlterTag != null) {
      alterString = _alterToString(xmlAlterTag.text);
    }

    if (state.transpose != 0) {
      throw XmlParserException(
          'Transposition of chord symbols currently unsupported');
    }

    return step + alterString;
  }

  /// Parse alter text to a string of one or two sharps/flats.
  ///
  /// Args:
  ///   alter_text: A string representation of an integer number of semitones.
  ///
  /// Returns:
  ///   A string, one of 'bb', 'b', '#', '##', or the empty string.
  ///
  /// Raises:
  ///   ChordSymbolParseError: If `alter_text` cannot be parsed to an integer,
  ///   or if the integer is not a valid number of semitones between -2 and 2
  ///   inclusive.
  String _alterToString(String alterText) {
    // Parse alter text to an integer number of semitones.
    try {
      final alterSemitones = int.parse(alterText);
      // Visual alter representation
      switch (alterSemitones) {
        case -2:
          return 'bb';
        case -1:
          return 'b';
        case 0:
          return '';
        case 1:
          return '#';
        case 2:
          return '##';
        default:
          throw XmlParserException('Invalid alter: $alterSemitones');
      }
    } catch (e) {
      throw XmlParserException('Non-integer alter: $alterText');
    }
  }

  /// Parse and return the <degree> scale degree modification element.
  String _parseDegree(XmlElement xmlDegree) {
    final xmlDegreeValue = xmlDegree.getElement('degree-value');
    if (xmlDegreeValue == null) {
      throw XmlParserException('Missing scale degree value in harmony');
    }
    final valueText = xmlDegreeValue.text;
    if (valueText.isEmpty) {
      throw XmlParserException('Missing scale degree');
    }
    try {
      final value = int.parse(valueText);

      var alterString = '';
      final xmlDegreeAlter = xmlDegree.getElement('degree-alter');
      if (xmlDegreeAlter != null) {
        final alterText = xmlDegreeAlter.text;
        alterString = _alterToString(alterText);
      }

      final xmlDegreeType = xmlDegree.getElement('degree-type');
      if (xmlDegreeType == null) {
        throw XmlParserException('Missing degree modification type');
      }
      final typeText = xmlDegreeType.text;
      String typeString;
      switch (typeText) {
        case 'add':
          if (alterString.isEmpty) {
            // When adding unaltered scale degree, use "add" string.
            typeString = 'add';
          } else {
            // When adding altered scale degree, "add" not necessary.
            typeString = '';
          }
          break;
        case 'subtract':
          typeString = 'no';
          // # Alter should be irrelevant when removing scale degree.
          alterString = '';
          break;
        case 'alter':
          if (alterString.isEmpty) {
            throw XmlParserException('Degree alteration by zero semitones');
          }
          // No type string necessary as merely appending e.g. "#9" suffices.
          typeString = '';
          break;
        default:
          throw XmlParserException(
              'Invalid degree modification type: $typeText');
      }

      // Return a scale degree modification string that can be appended to a chord
      // symbol figure string.
      return '$typeString$alterString$value';
    } catch (_) {
      throw XmlParserException('Non-integer scale degree: $valueText');
    }
  }
}
