// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html' as html show window;
import 'dart:js' as js;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:pitch_detector_plus_platform_interface/pitch_detector_plus_platform_interface.dart';

final controller = StreamController.broadcast();

/// A web implementation of the PitchDetectorPlatform of the PitchDetector plugin.
class PitchDetectorPlusWeb extends PitchDetectorPlusPlatform {
  PitchDetectorPlusWeb();

  static late final MethodChannel _channel;
  static late final PluginEventChannel _eventChannel;

  static void registerWith(Registrar registrar) {
    _channel = MethodChannel(
      'pitch_detector',
      const StandardMethodCodec(),
      registrar,
    );
    _eventChannel = PluginEventChannel(
      'pitch_detector_event_channel',
      const StandardMethodCodec(),
      registrar,
    );
    PitchDetectorPlusPlatform.instance = PitchDetectorPlusWeb();
    _channel.setMethodCallHandler(
      PitchDetectorPlusPlatform.instance.handleMethodCall,
    );
    _eventChannel.setController(controller);
  }

  @override
  Future<void> handleMethodCall(MethodCall call) async {
    print('=== WEB ===');
    print(call.method);
    print(call.arguments);
    switch (call.method) {
      // case 'handleRedirectFuture':
      //   B2CProviderWeb.storeRedirectHash();
      //   return "B2C_PLUGIN_DEFAULT";
      //
    }
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  /// Returns a [String] containing the status of the recording.
  @override
  Future<String> startRecording() async {
    js.context.callMethod('startPitchDetect', [
      (List<double> data) {
        controller.add({
          'data': data,
          'type': 'PITCH_RAW_DATA',
        });
      },
    ]);
    return 'startRecording';
  }

  /// Returns a [String] containing the status of the recording.
  @override
  Future<String> stopRecording() async {
    js.context.callMethod('stopRecording');
    return 'startRecording';
  }

  @override
  Stream listen() {
    return controller.stream;
  }

  @override
  Future<Map> initialize() async {
    final sampleRate = await js.context.callMethod('getSampleRate');
    return {
      'sampleRate': sampleRate,
      'bufferSize': 1024,
    };
  }

  @override
  Future<bool?> isInitialized() async {
    return true;
  }
}
