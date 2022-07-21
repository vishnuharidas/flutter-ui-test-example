import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_ping/util/PingUtils.dart';
import 'package:test/test.dart';

void main() {

  // Ref: https://github.com/point-source/dart_ping/blob/main/dart_ping/test/dart_ping_test.dart
  test('Ping library actually pings google.com', () async {

    var ping = Ping('google.com', count: 1);

    var data = await ping.stream.first;

    expect(data, isA<PingData>());
    expect(data.error, null);

  });

  test('getIP() returns the correct IP address', () async {

    // Generating a list of random `PingData`. It should find the FIRST item with `PingResponse` object
    // and return the IP address.
    List<PingData> pingData = [
      PingData(error: PingError(ErrorType.Unknown)),
      PingData(summary: PingSummary(transmitted: 1, received: 1)),
      PingData(response: PingResponse(ip: "1.2.3.4")),
      PingData(response: PingResponse(ip: "another-ip-1")),
      PingData(response: PingResponse(ip: "another-ip-2")),
      PingData(response: PingResponse(ip: "another-ip-3")),
      PingData(error: PingError(ErrorType.RequestTimedOut)),
      PingData(summary: PingSummary(transmitted: 3, received: 3)),
      PingData(response: PingResponse(ip: "another-ip-4")),
    ];

    var actual = getIP(pingData);

    expect(actual, "1.2.3.4");

  });

  test('getTotalMillis() returns the total time of ping requests in milliseconds', () async {

    List<Duration> durations = [
      Duration(seconds: 2),
      Duration(milliseconds: 100),
      Duration(minutes: 1),
      Duration(milliseconds: 1000),
      Duration(days: 2)
    ];

    int expected = durations.fold(0, (previousValue, element) => previousValue + element.inMilliseconds);

    // Generating a list of random `PingData`. It should calculate the total from this.
    List<PingData> pingData = [
      PingData(error: PingError(ErrorType.Unknown)),
      PingData(summary: PingSummary(transmitted: 1, received: 1)),
    ];

    // Add the durations.
    for (var element in durations) {
      pingData.add(
          PingData(response: PingResponse(time: element))
      );
    }

    // Add another set of other items
    pingData.addAll([
      PingData(error: PingError(ErrorType.Unknown)),
      PingData(summary: PingSummary(transmitted: 1, received: 1)),
    ]);

    // Verify the number of items
    expect(pingData.length, 9);

    var actual = getTotalMillis(pingData);

    expect(actual, expected);

  });

  test('getTotalMillis() returns zero when no time data is available', () async {

    // Generating a list of random `PingData`. It should calculate the total from this.
    List<PingData> pingData = [
      PingData(error: PingError(ErrorType.Unknown)),
      PingData(summary: PingSummary(transmitted: 1, received: 1)),
      PingData(error: PingError(ErrorType.RequestTimedOut)),
      PingData(summary: PingSummary(transmitted: 5, received: 5)),
    ];

    // Verify the number of items
    expect(pingData.length, 4);

    expect(getTotalMillis(pingData), 0);

  });


}
