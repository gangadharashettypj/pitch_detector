import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/services.dart';

import 'pitch_detector_platform_interface.dart';

const MethodChannel _channel = MethodChannel('pitch_detector');
const EventChannel _eventChannel = EventChannel('pitch_detector_event_channel');

/// An implementation of [UrlLauncherPlatform] that uses method channels.
class MethodChannelPitchDetector extends PitchDetectorPlatform {
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
