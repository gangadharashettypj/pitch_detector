import 'pitch_detector_platform_interface.dart';

class PitchDetector {
  Future<String?> getPlatformVersion() {
    return PitchDetectorPlatform.instance.getPlatformVersion();
  }

  Future<String?> startRecording() async {
    return PitchDetectorPlatform.instance.startRecording();
  }

  Future<String?> stopRecording() async {
    return PitchDetectorPlatform.instance.stopRecording();
  }

  Stream listenToPitchData() {
    return PitchDetectorPlatform.instance.listenToPitchData();
  }

  Future<String?> init() async {
    return PitchDetectorPlatform.instance.initialize();
  }

  Future<bool?> isInitialized() async {
    return PitchDetectorPlatform.instance.isInitialized();
  }
}
