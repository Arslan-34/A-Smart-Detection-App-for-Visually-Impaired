import 'package:flutter_tts/flutter_tts.dart';

enum ModelType { currency, indoor }

class ModelHelper {
  static FlutterTts? _flutterTts;
  static bool _ttsEnabled = true;

  /// Initialize the TTS engine
  static Future<void> initTTS() async {
    _flutterTts ??= FlutterTts();
  }

  /// Toggle voice feedback globally
  static void toggleTTS(bool value) {
    _ttsEnabled = value;
  }

  /// Speak a message (if TTS is enabled)
  static Future<void> speak(String message) async {
    if (!_ttsEnabled) return;
    await initTTS();
    await _flutterTts?.speak(message);
  }

  /// Clean up the TTS engine
  static Future<void> dispose() async {
    await _flutterTts?.stop();
    _flutterTts = null;
  }
}
