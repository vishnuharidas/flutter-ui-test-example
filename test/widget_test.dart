import 'package:flutter/material.dart';
import 'package:flutter_ping/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('Ping button updates the summary text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Check for the "Ping google.com" button
    expect(find.byKey(Key("home-screen-ping-button")), findsOneWidget);

    // Trigger a ping
    await tester.tap(find.byKey(Key("home-screen-ping-button")));
    await tester.pumpAndSettle();

    // Verify that the "Total Millis" changes its value to "Waiting" because of the state change.
    expect(find.textContaining("Waiting..."), findsOneWidget);
  });

  testWidgets('Ping button is disabled when pinging', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Check for the "Ping google.com" button
    expect(find.byKey(Key("home-screen-ping-button")), findsOneWidget);

    // Trigger a ping
    await tester.tap(find.byKey(Key("home-screen-ping-button")));
    await tester.pumpAndSettle();

    // Verify that when pinging, the click listener is `null` (that means it is disabled for clicking)
    expect(tester.widget<ElevatedButton>(find.byKey(Key("home-screen-ping-button"))).onPressed, null);
  });

}
