import 'package:flutter/material.dart';
import 'package:flutter_ping/ui/HomeScreen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_ping/main.dart' as app;

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Ping button starts a ping and changes states', (WidgetTester tester) async {

    app.main();
    await tester.pumpAndSettle();

    final StatefulElement homeElement = tester.element(find.byType(HomeScreen));
    final HomeScreenState homeState = homeElement.state as HomeScreenState;

    // Initial state - none.
    expect(homeState.pingStatus, PingStatus.none);

    await tester.pumpAndSettle();

    // Error shouldn't be visible
    expect(tester.widget<Visibility>(find.byKey(Key("home-screen-ping-error-text"))).visible, false);

    // Trigger a ping
    await tester.tap(find.byKey(Key("home-screen-ping-button")));
    await tester.pumpAndSettle();

    // New state - pinging.
    expect(homeState.pingStatus, PingStatus.pinging);

    await tester.pumpAndSettle();

    // Error shouldn't be visible
    expect(tester.widget<Visibility>(find.byKey(Key("home-screen-ping-error-text"))).visible, false);

    // Add 6 second delay to wait for the ping to finish
    await Future.delayed(Duration(seconds: 6));

    // New state - finished.
    expect(homeState.pingStatus, PingStatus.finished);

    await tester.pumpAndSettle();

    // Error shouldn't be visible
    expect(tester.widget<Visibility>(find.byKey(Key("home-screen-ping-error-text"))).visible, false);

  });

  testWidgets('Error should be visible when ping fails', (WidgetTester tester) async {

    app.main();
    await tester.pumpAndSettle();

    final StatefulElement homeElement = tester.element(find.byType(HomeScreen));
    final HomeScreenState homeState = homeElement.state as HomeScreenState;

    // Initial state - none.
    expect(homeState.pingStatus, PingStatus.none);

    await tester.pumpAndSettle();

    // Error shouldn't be visible
    expect(tester.widget<Visibility>(find.byKey(Key("home-screen-ping-error-text"))).visible, false);

    // Ping something invalid
    homeState.pingUrl(url: "not-a-url!", count: 1);

    // Wait for a sec
    await Future.delayed(Duration(seconds: 3));

    // New state - pinging
    expect(homeState.pingStatus, PingStatus.error);

    await tester.pumpAndSettle();

    // Error shouldn't be visible
    expect(tester.widget<Visibility>(find.byKey(Key("home-screen-ping-error-text"))).visible, true);


  });
}
