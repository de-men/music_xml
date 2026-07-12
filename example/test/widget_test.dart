// Widget test for the MusicXML example app.
//
// The app (example/lib/main.dart) shows an AppBar titled
// "Flutter Demo Home Page" and two MusicItem widgets that each
// asynchronously parse a MusicXML asset (assets/musicXML.xml and
// assets/test.xml) via a FutureBuilder, rendering
// "movement-title: ..." and "totalTimeSecs: ..." once loading completes.
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
  testWidgets('shows AppBar title and parsed MusicXML content for both assets',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Initially both MusicItem widgets show a loading spinner.
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await _pumpUntilLoaded(tester);

    // The AppBar title is unchanged from the Flutter template.
    expect(find.text('Flutter Demo Home Page'), findsOneWidget);

    // No more spinners once both assets have finished loading.
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // assets/musicXML.xml has movement-title "It's All In The Game" and,
    // per the music_xml package, a totalTimeSecs of 49.5.
    expect(find.text("movement-title: It's All In The Game"), findsOneWidget);
    expect(find.text('totalTimeSecs: 49.500000000000014'), findsOneWidget);

    // assets/test.xml has no <movement-title> element and a
    // totalTimeSecs of 8.0.
    expect(find.text('movement-title: null'), findsOneWidget);
    expect(find.text('totalTimeSecs: 8.0'), findsOneWidget);
  });
}
