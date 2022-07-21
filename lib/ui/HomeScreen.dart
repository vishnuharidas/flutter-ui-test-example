import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ping/util/PingUtils.dart';

enum PingStatus {
  none,
  pinging,
  finished,
  error,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Ping? _ping;

  final List<PingData> _pingResponse = [];

  PingStatus pingStatus = PingStatus.none;

  final _buttonKey = Key("home-screen-ping-button");
  final _errorTextKey = Key("home-screen-ping-error-text");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Ping"),
      ),
      body: Column(
        children: [
          // Button
          ElevatedButton.icon(
              key: _buttonKey,
              onPressed: pingStatus == PingStatus.pinging
                  ? null
                  : () {
                      pingUrl(url: "google.com");
                    },
              label: Text("Ping google.com"),
              icon: Icon(Icons.search)),

          // Show the summary: IP and total Millis
          // We could use a "Visibility" widget, but for the time being, checking state and showing
          // the values accordingly

          // IP Address
          Text("IP Address: ${pingStatus == PingStatus.none ? "Not yet started." : getIP(_pingResponse)}"),

          // Total milliseconds
          Text("Total Millis: ${_getTotalMillisStr()}"),

          Visibility(
            key: _errorTextKey,
            visible: pingStatus == PingStatus.error,
            child: Text(
              "Ping error. Please try again",
              style: TextStyle(color: Colors.red),
            ),
          ),

          Divider(),

          Text("Log"),

          // List of events
          Expanded(
            child: ListView.builder(
                itemCount: _pingResponse.length,
                itemBuilder: (context, index) {
                  // Not formatting the log now, just displaying as it is using `toString()`.
                  return Text(_pingResponse[index].toString());
                }),
          )
        ],
      ),
    );
  }

  String _getTotalMillisStr() {
    switch (pingStatus) {
      case PingStatus.none    : return "Not yet started";
      case PingStatus.pinging : return "Waiting...";
      case PingStatus.finished: return "${getTotalMillis(_pingResponse)}ms";
      case PingStatus.error   : return "Ping error";
    }
  }

  void pingUrl({String url = "example.com", int count = 5}) async {

    _ping?.stop(); // Stop `Ping` if it is already running.

    _ping = Ping(url, count: count);

    setState(() {
      pingStatus = PingStatus.pinging;
      _pingResponse.clear();
    });

    _ping?.stream.listen((event) {
      setState(() {

        _pingResponse.add(event);

        if(event.error != null){
          pingStatus = PingStatus.error;
        } else if (event.summary != null) {  // Reached the end? (Ping ends with a `PingSummary` record)
          pingStatus = PingStatus.finished;
        }

      });
    });
  }
}
