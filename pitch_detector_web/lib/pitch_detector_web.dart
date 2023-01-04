import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class PitchDetectorPlusPlugin {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'pitch_detector',
      const StandardMethodCodec(),
      registrar,
    );
    final PitchDetectorPlusPlugin instance = PitchDetectorPlusPlugin();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'launch':
        final String url = call.arguments['url'];
        return 'Hello $url';
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The url_launcher plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }
}
