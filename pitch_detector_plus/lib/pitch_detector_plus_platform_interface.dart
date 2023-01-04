import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pitch_detector_plus_method_channel.dart';

abstract class PitchDetectorPlusPlatform extends PlatformInterface {
  /// Constructs a PitchDetectorPlusPlatform.
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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
