import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pitch_detector_plus_platform_interface/pitch_detector_platform_interface.dart';

/// An implementation of [PitchDetectorPlatform] that uses method channels.
class PitchDetectorPlus {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pitch_detector');

  @visibleForTesting
  final eventChannel = const EventChannel('pitch_detector_event_channel');

  Future<String?> getPlatformVersion() async {
    final version =
        await PitchDetectorPlusPlatform.instance.getPlatformVersion();
    return version;
  }

  Future<String?> startRecording() async {
    final status = await PitchDetectorPlusPlatform.instance.startRecording();
    return status;
  }

  Future<String?> stopRecording() async {
    final status = await PitchDetectorPlusPlatform.instance.stopRecording();
    return status;
  }

  Stream listenToPitchData() {
    return eventChannel.receiveBroadcastStream();
    //     .where((event) {
    //   return event is Map && event['type'] == 'PITCH_RAW_DATA';
    // });
  }

  Future<String?> initialize() async {
    final status = await PitchDetectorPlusPlatform.instance.initialize();
    return status;
  }

  Future<bool?> isInitialized() async {
    final status = await PitchDetectorPlusPlatform.instance.isInitialized();
    return status;
  }
}
