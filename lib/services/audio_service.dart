import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  bool hasSource = false;
  bool isPlaying = false;

  Future<void> loadScenarioAudio(String scenarioId, String langCode) async {
    hasSource = false;
    isPlaying = false;
    final assetPath = 'assets/audio/${scenarioId}_$langCode.mp3';
    try {
      await _player.setAsset(assetPath);
      hasSource = true;
    } on PlatformException catch (_) {
      hasSource = false;
    } catch (_) {
      hasSource = false;
    }
  }

  Future<void> play() async {
    if (!hasSource) return;
    try {
      await _player.play();
      isPlaying = true;
    } catch (_) {
      isPlaying = false;
    }
  }

  Future<void> pause() async {
    if (!hasSource) return;
    try {
      await _player.pause();
      isPlaying = false;
    } catch (_) {
      isPlaying = false;
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
