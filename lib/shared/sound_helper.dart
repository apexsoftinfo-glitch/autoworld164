import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundHelper {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSuccessChime() async {
    try {
      // Stop currently playing to support rapid multi-clicks/successes instantly
      await _player.stop();
      await _player.play(AssetSource('audio/success.wav'));
    } catch (e) {
      debugPrint('❌ [SoundHelper] Error playing success sound: $e');
    }
  }
}
