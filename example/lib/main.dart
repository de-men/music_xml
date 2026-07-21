import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_xml/music_xml.dart' hide Key;
import 'package:xml/xml.dart';

import 'mute_solo_extension.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Flutter Demo Home Page'),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full score with movement-title and total time.
          MusicItem(
            label: 'musicXML.xml (full score)',
            xmlFile: 'musicXML.xml',
          ),
          // Standard volume/pan plus a namespaced mute/solo extension.
          MusicItem(
            label: 'mute-solo.xml (volume/pan + mute/solo)',
            xmlFile: 'mute-solo.xml',
            showMidiInstrument: true,
            showMuteSolo: true,
          ),
        ],
      ),
    );
  }
}

class MusicItem extends StatelessWidget {
  final String label;
  final String xmlFile;
  final bool showMidiInstrument;
  final bool showMuteSolo;

  const MusicItem({
    required this.label,
    required this.xmlFile,
    this.showMidiInstrument = false,
    this.showMuteSolo = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MusicXmlDocument>(
      future: rootBundle
          .loadString('assets/$xmlFile')
          .then((value) => MusicXmlDocument.parse(value)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final document = snapshot.data!;
          final score = document.score;
          final scorePartwise = score.getElement('score-partwise');
          final movementTitle = scorePartwise?.getElement('movement-title');
          final midiInstrument = showMidiInstrument
              ? score.partList.scoreParts.values.first.midiInstruments.first
              : null;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                Text('movement-title: ${movementTitle?.innerText}'),
                const SizedBox(height: 16),
                Text('totalTimeSecs: ${document.totalTimeSecs}'),
                if (midiInstrument != null) ...[
                  Text('volume: ${midiInstrument.volume?.content.value}'),
                  Text('pan: ${midiInstrument.pan?.content.value}'),
                ],
                if (showMuteSolo && midiInstrument != null) ...[
                  Text('muted: ${midiInstrument.isMuted}'),
                  Text('solo: ${midiInstrument.isSolo}'),
                ],
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
