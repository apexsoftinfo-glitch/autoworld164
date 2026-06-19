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

  static Future<void> playBackupDoneChime() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/beckup_done.mp3'));
    } catch (e) {
      debugPrint('❌ [SoundHelper] Error playing backup done sound: $e');
    }
  }

  static Future<void> playDeleteChime() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/delete.mp3'));
    } catch (e) {
      debugPrint('❌ [SoundHelper] Error playing delete sound: $e');
    }
  }

  static Future<void> playTransferChime() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/transfer.mp3'));
    } catch (e) {
      debugPrint('❌ [SoundHelper] Error playing transfer sound: $e');
    }
  }
}
