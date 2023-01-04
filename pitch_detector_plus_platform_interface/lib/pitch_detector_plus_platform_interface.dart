import 'package:flutter/services.dart';
import 'package:pitch_detector_plus_platform_interface/method_channel_pitch_detector.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class PitchDetectorPlusPlatform extends PlatformInterface {
  /// Constructs a PitchDetectorPlatform.
  PitchDetectorPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static PitchDetectorPlusPlatform _instance = MethodChannelPitchDetectorPlus();

  /// The default instance of [PitchDetectorPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelPitchDetectorPlus].
  static PitchDetectorPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PitchDetectorPlusPlatform] when
  /// they register themselves.
  static set instance(PitchDetectorPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<dynamic> handleMethodCall(MethodCall call) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> startRecording() {
    throw UnimplementedError('startRecording() has not been implemented.');
  }

  Future<String?> stopRecording() {
    throw UnimplementedError('stopRecording() has not been implemented.');
  }

  Stream listenToPitchData() {
    throw UnimplementedError('listenToPitchData() has not been implemented.');
  }

  Future<String?> initialize() async {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<bool?> isInitialized() async {
    throw UnimplementedError('isInitialized() has not been implemented.');
  }
}
