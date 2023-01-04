// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'pitch_detector_platform_interface.dart';

/// A web implementation of the PitchDetectorPlatform of the PitchDetector plugin.
class PitchDetectorWeb extends PitchDetectorPlatform {
  /// Constructs a PitchDetectorWeb
  PitchDetectorWeb();
  static late final MethodChannel _channel;
  static late final EventChannel _eventChannel;

  static void registerWith(Registrar registrar) {
    _channel = MethodChannel(
      'pitch_detector',
      const StandardMethodCodec(),
      registrar,
    );
    _eventChannel = EventChannel(
      'pitch_detector_event_channel',
      const StandardMethodCodec(),
      registrar,
    );
    _channel
        .setMethodCallHandler(PitchDetectorPlatform.instance.handleMethodCall);
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
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  /// Returns a [String] containing the status of the recording.
  @override
  Future<String?> startRecording() async {
    final status = await _channel.invokeMethod('startRecording');
    return status;
  }

  /// Returns a [String] containing the status of the recording.
  @override
  Future<String?> stopRecording() async {
    final status = await _channel.invokeMethod('stopRecording');
    return status;
  }

  @override
  Stream listenToPitchData() {
    return _eventChannel
        .receiveBroadcastStream()
        .where((event) => event is Map && event['type'] == 'PITCH_RAW_DATA');
  }

  @override
  Future<String?> initialize() async {
    final status = await _channel.invokeMethod<String>('initialize');
    return status;
  }

  @override
  Future<bool?> isInitialized() async {
    final status = await _channel.invokeMethod<bool>('isInitialized');
    return status;
  }
}
