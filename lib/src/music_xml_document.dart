import 'dart:math';

import 'package:xml/xml.dart';

import 'music_xml_parser_state.dart';
import 'part.dart';
import 'score_part.dart';

/// Internal representation of a MusicXML Document.
/// Represents the top level object which holds the MusicXML document
/// Responsible for loading the .xml or .mxl file using the _get_score method
/// If the file is .mxl, this class uncompresses it
/// After the file is loaded, this class then parses the document into memory
/// using the parse method.
class MusicXmlDocument extends XmlDocument {
  final XmlDocument score;

  /// ScoreParts indexed by id.
  final Map<String, ScorePart> scoreParts;

  final List<Part> parts;

  /// Total time in seconds
  final double totalTimeSecs;

  /// Parse the uncompressed MusicXML document.
  factory MusicXmlDocument.parse(String input) {
    final score = XmlDocument.parse(input);

    // Parse part-list
    final scoreParts = <String, ScorePart>{};
    score
        .findAllElements('part-list')
        .where((element) => element.getElement('score-part') != null)
        .map((element) => element.getElement('score-part')!)
        .map((element) => ScorePart.parse(element))
        .forEach((element) => scoreParts[element.id] = element);

    // Parse parts
    final state = MusicXMLParserState();
    var totalTimeSecs = 0.0;
    final parts = score.findAllElements('part').map((element) {
      final part = Part.parse(element, scoreParts, state);
      totalTimeSecs = max(totalTimeSecs, state.timePosition);
      return part;
    }).toList();

    return MusicXmlDocument._(score, scoreParts, parts, totalTimeSecs);
  }

  MusicXmlDocument._(
    this.score,
    this.scoreParts,
    this.parts,
    this.totalTimeSecs,
  );
}
