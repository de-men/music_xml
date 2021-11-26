import 'package:xml/xml.dart';

import 'measure.dart';
import 'music_xml_parser_state.dart';
import 'score_part.dart';

/// Internal represention of a MusicXML <part> element.
class Part {
  late final String id;
  late final ScorePart scorePart;
  final measures = <Measure>[];

  /// Parse the <part> element.
  Part(
    XmlElement xmlPart,
    Map<String, ScorePart> scoreParts,
    MusicXMLParserState state,
  ) {
    id = xmlPart.getAttribute('id') ?? '';
    scorePart = scoreParts[id] ?? ScorePart();

    // Reset the time position when parsing each part
    state.timePosition = 0;
    state.midiChannel = scorePart.midiChannel;
    state.midiProgram = scorePart.midiProgram;
    state.transpose = 0;

    final xmlMeasures = xmlPart.findAllElements('measure');
    for (var measure in xmlMeasures) {
      // Issue #674: Repair measures that do not contain notes
      // by inserting a whole measure rest
      _repairEmptyMeasure(measure);
      final parsedMeasure = Measure(measure, state);
      measures.add(parsedMeasure);
    }
  }

  /// Repair a measure if it is empty by inserting a whole measure rest.
  /// If a <measure> only consists of a <forward> element that advances
  /// the time cursor, remove the <forward> element and replace
  /// with a whole measure rest of the same duration.
  void _repairEmptyMeasure(XmlElement measure) {
    final xmlForwards = measure.findAllElements('forward');
    final forwardCount = xmlForwards.length;
    final noteCount = measure.findAllElements('note').length;
    if (noteCount == 0 && forwardCount == 1) {
      // Get the duration of the <forward> element
      // TODO final xmlForward = xmlForwards.single;
      // final xmlDuration = xmlForward.getElement('duration');
      // final forwardDuration = int.tryParse(xmlDuration?.text ?? '') ?? 0;

      // # Delete the <forward> element
      // measure.remove(xml_forward)
      //
      // # Insert the new note
      // new_note = '<note>'
      // new_note += '<rest /><duration>' + str(forward_duration) + '</duration>'
      // new_note += '<voice>1</voice><type>whole</type><staff>1</staff>'
      // new_note += '</note>'
      // new_note_xml = ET.fromstring(new_note)
      // measure.append(new_note_xml)
    }
  }
}
