//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_audio_capture/flutter_audio_capture_plugin.h>
#include <pitch_detector_plus/pitch_detector_plus_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutter_audio_capture_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterAudioCapturePlugin");
  flutter_audio_capture_plugin_register_with_registrar(flutter_audio_capture_registrar);
  g_autoptr(FlPluginRegistrar) pitch_detector_plus_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "PitchDetectorPlusPlugin");
  pitch_detector_plus_plugin_register_with_registrar(pitch_detector_plus_registrar);
}
