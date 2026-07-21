// Widget test for the MusicXML example app.
//
// Assets shown by example/lib/main.dart:
// - musicXML.xml: full score with movement-title and total time
// - mute-solo.xml: standard volume/pan plus a mute/solo namespaced extension
//
// Note: rootBundle.loadString for the larger asset (musicXML.xml, ~75KB)
// does not resolve under fake-async tester.pump() alone; the test uses
// tester.runAsync() to let the real async asset load complete between
// pumps.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

Future<void> _pumpUntilLoaded(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
      return;
    }
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }
}

void main() {
  testWidgets('shows AppBar title and parsed MusicXML content for assets',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Initially MusicItem widgets show a loading spinner.
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await _pumpUntilLoaded(tester);

    // The AppBar title is unchanged from the Flutter template.
    expect(find.text('Flutter Demo Home Page'), findsOneWidget);

    // No more spinners once assets have finished loading.
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // assets/musicXML.xml has movement-title "It's All In The Game" and,
    // per the music_xml package, a totalTimeSecs of 49.5.
    expect(find.text('musicXML.xml (full score)'), findsOneWidget);
    expect(find.text("movement-title: It's All In The Game"), findsOneWidget);
    expect(find.text('totalTimeSecs: 49.500000000000014'), findsOneWidget);

    // assets/mute-solo.xml shows standard volume/pan plus namespaced
    // mute/solo extension attributes, and has no <movement-title>.
    expect(
      find.text('mute-solo.xml (volume/pan + mute/solo)'),
      findsOneWidget,
    );
    expect(find.text('volume: 80.0'), findsOneWidget);
    expect(find.text('pan: 0.0'), findsOneWidget);
    expect(find.text('muted: true'), findsOneWidget);
    expect(find.text('solo: false'), findsOneWidget);
    expect(find.text('movement-title: null'), findsOneWidget);
  });
}
