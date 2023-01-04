import 'dart:async';

import 'package:flutter/services.dart';

import 'pitch_detector_plus_platform_interface.dart';

const MethodChannel _channel = MethodChannel('pitch_detector');
const EventChannel _eventChannel = EventChannel('pitch_detector_event_channel');

/// An implementation of [PitchDetectorPlusPlatform] that uses method channels.
class MethodChannelPitchDetectorPlus extends PitchDetectorPlusPlatform {
  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = await _channel.invokeMethod('getPlatformVersion');
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
