import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pitch_detector/pitch_detector_plus.dart';
import 'package:pitch_detector_dart/pitch_detector.dart' as pd;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pitchDetectorDart = PitchDetector();
  final pitchDart = pd.PitchDetector(44100, 812);
  StreamSubscription? streamSub;

  var note = "";
  var status = "Click on start";

  Future<void> _startCapture() async {
    // await _audioRecorder.start(listener, onError,
    //     sampleRate: 44100, bufferSize: 3000);
    pitchDetectorDart.startRecording();
    streamSub = pitchDetectorDart.listenToPitchData().listen((event) {
      // print(event);
      listener(List<double>.from(event['data']));
    });
    setState(() {
      note = "";
      status = "Play something";
    });
  }

  Future<void> _stopCapture() async {
    pitchDetectorDart.stopRecording();
    // await _audioRecorder.stop();
    streamSub?.cancel();

    setState(() {
      note = "";
      status = "Click on start";
    });
  }

  void listener(List<double> audioSample) {
    final result = pitchDart.getPitch(audioSample);

    print('${DateTime.now().toString()}   ${result.pitch}');
    setState(() {
      note = result.pitch.toStringAsFixed(1);
    });
  }

  void onError(Object e) {
    print(e);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
          const Spacer(),
          Center(
              child: Text(
            note,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 105.0,
                fontWeight: FontWeight.bold),
          )),
          const Spacer(),
          Center(
              child: Text(
            status,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
          )),
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: Center(
                  child: FloatingActionButton(
                    onPressed: () {
                      pitchDetectorDart.initialize();
                    },
                    child: const Text("Init"),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: FloatingActionButton(
                    onPressed: _startCapture,
                    child: const Text("Start"),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: FloatingActionButton(
                    onPressed: _stopCapture,
                    child: const Text("Stop"),
                  ),
                ),
              ),
            ],
          ))
        ]),
      ),
    );
  }
}
