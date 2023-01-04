import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pitch_detector_platform_interface.dart';

/// An implementation of [PitchDetectorPlatform] that uses method channels.
class MethodChannelPitchDetector extends PitchDetectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pitch_detector');

  @visibleForTesting
  final eventChannel = const EventChannel('pitch_detector_event_channel');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> startRecording() async {
    final status = await methodChannel.invokeMethod<String>('startRecording');
    return status;
  }

  @override
  Future<String?> stopRecording() async {
    final status = await methodChannel.invokeMethod<String>('stopRecording');
    return status;
  }

  @override
  Stream listenToPitchData() {
    return eventChannel.receiveBroadcastStream();
    //     .where((event) {
    //   return event is Map && event['type'] == 'PITCH_RAW_DATA';
    // });
  }

  @override
  Future<String?> initialize() async {
    final status = await methodChannel.invokeMethod<String>('initialize');
    return status;
  }

  @override
  Future<bool?> isInitialized() async {
    final status = await methodChannel.invokeMethod<bool>('isInitialized');
    return status;
  }
}
