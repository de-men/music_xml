import 'package:music_xml/src/element/score_partwise.dart';
import 'package:xml/xml.dart';

/// Internal representation of a MusicXML Document.
/// Represents the top level object which holds the MusicXML document
/// Responsible for loading the .xml or .mxl file using the _get_score method
/// If the file is .mxl, this class uncompresses it
/// After the file is loaded, this class then parses the document into memory
/// using the parse method.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/score-partwise/
class MusicXmlDocument extends XmlDocument {

  final ScorePartwise score;
  
  /// Title of the piece
  String get title => score.movementTitle?.title ?? 'Unknown Piece';
  
  /// Total time in seconds
  double get totalTimeSecs => score.totalTimeSecs;


  /// Parse the uncompressed MusicXML document.
  factory MusicXmlDocument.parse(String input) {
    return MusicXmlDocument.fromXml(XmlDocument.parse(input));
  }

  factory MusicXmlDocument.fromXml(XmlDocument score) {
    final scorePartwiseElement = score.getElement('score-partwise')!;
    final scorePartwise = ScorePartwise.fromXml(scorePartwiseElement);
    return MusicXmlDocument(scorePartwise);
  }

  MusicXmlDocument(this.score) : super([score]);
}
