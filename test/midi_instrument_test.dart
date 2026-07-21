import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

final instrumentChangeAsset = File('test/assets/instrument-change-element.xml');

const _score = '''
<score-partwise version="4.0">
  <part-list>
    <score-part id="P1">
      <part-name>Music</part-name>
      <midi-instrument
          id="P1-I1"
          xmlns:mute-solo="https://example.com/musicxml/mute-solo"
          mute-solo:mute="yes"
          mute-solo:solo="no">
        <midi-channel>1</midi-channel>
        <midi-program>41</midi-program>
        <volume>78.7402</volume>
        <pan>-30</pan>
      </midi-instrument>
    </score-part>
  </part-list>
  <part id="P1">
    <measure number="1"/>
  </part>
</score-partwise>''';

void main() {
  test('official <instrument-change> example keeps volume and pan', () {
    final document = MusicXmlDocument.parse(
      instrumentChangeAsset.readAsStringSync(),
    );
    final instrument =
        document.score.partList.scoreParts['P1']!.midiInstruments.single;

    expect(instrument.volume?.content, Percent(80));
    expect(instrument.pan?.content, RotationDegrees(0));

    final xml = document.toXmlString();
    expect(xml, contains('<volume>80.0</volume>'));
    expect(xml, contains('<pan>0.0</pan>'));

    final reparsed = MusicXmlDocument.parse(xml);
    final reparsedInstrument =
        reparsed.score.partList.scoreParts['P1']!.midiInstruments.single;
    expect(reparsedInstrument.volume?.content.value, 80);
    expect(reparsedInstrument.pan?.content.value, 0);
  });

  test('namespaced mute/solo extension attributes round-trip', () {
    final document = MusicXmlDocument.parse(_score);
    final instrument =
        document.score.partList.scoreParts['P1']!.midiInstruments.single;

    expect(
      instrument.extensionAttributes
          .firstWhere(
            (attribute) => attribute.name.qualified == 'mute-solo:mute',
          )
          .value,
      'yes',
    );

    final xml = document.toXmlString();
    expect(
      xml,
      contains(
        'xmlns:mute-solo="https://example.com/musicxml/mute-solo" '
        'mute-solo:mute="yes" mute-solo:solo="no"',
      ),
    );

    final reparsed = MusicXmlDocument.parse(xml);
    final attributes = reparsed
        .score
        .partList
        .scoreParts['P1']!
        .midiInstruments
        .single
        .extensionAttributes;
    expect(
      attributes
          .firstWhere(
            (attribute) => attribute.name.qualified == 'mute-solo:solo',
          )
          .value,
      'no',
    );
  });
}
