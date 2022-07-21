import 'package:dart_ping/dart_ping.dart';

// Gets the IP address from the FIRST `PingResponse` object. Ignores everything else.
String? getIP(List<PingData> list) {
  try {
    return list.firstWhere((element) => element.response != null).response?.ip;
  } catch (e) {
    return null;
  }
}

// Returns the sum of time in each `PingResponse` record.
int getTotalMillis(List<PingData> list) {
  try {
    return list
        .where((element) => element.response != null)
        .fold(0, (previousValue, element) => previousValue + (element.response?.time?.inMilliseconds ?? 0));
  } catch (e) {
    return 0;
  }
}
