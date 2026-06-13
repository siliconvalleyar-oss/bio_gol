import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService._();
  static final AudioPlayer _player = AudioPlayer();
  static StreamSubscription? _completionSub;

  static Future<void> play(String filename) async {
    try {
      await _player.stop();
      _completionSub?.cancel();
      final completer = Completer<void>();
      _completionSub = _player.onPlayerComplete.listen((_) {
        if (!completer.isCompleted) completer.complete();
      });
      await _player.play(AssetSource('audio/$filename'));
      await completer.future.timeout(const Duration(seconds: 15));
    } catch (_) {}
  }

  static Future<void> playWithDelay(String filename, {int delayMs = 0}) async {
    if (delayMs > 0) {
      await Future.delayed(Duration(milliseconds: delayMs));
    }
    await play(filename);
  }

  static Future<void> playChain(
    List<String> filenames, {
    int gapMs = 500,
  }) async {
    for (final fn in filenames) {
      await play(fn);
      await Future.delayed(Duration(milliseconds: gapMs));
    }
  }

  static Future<void> feedback({
    required bool correcta,
    required int racha,
    int totalPreguntas = 0,
    int correctas = 0,
  }) async {
    if (correcta) {
      final pct = totalPreguntas > 0 ? correctas / totalPreguntas : 0;
      if (pct >= 1.0 && totalPreguntas >= 10) {
        await play('larompiste.mp3');
      } else if (racha >= 8) {
        await play('crack.mp3');
      } else if (racha >= 5) {
        await play('genio.mp3');
      } else if (racha >= 3) {
        await play('vamosbien.mp3');
      } else {
        final opts = ['correcto.mp3', 'gol.mp3', 'golazo.mp3', 'perfecto.mp3'];
        await play(opts[Random().nextInt(opts.length)]);
      }
    } else {
      final pct = totalPreguntas > 0 ? correctas / totalPreguntas : 0;
      if (totalPreguntas >= 5 && pct < 0.5) {
        final opts = ['debesestudiar.mp3', 'entrenaconlibros.mp3'];
        await play(opts[Random().nextInt(opts.length)]);
      } else {
        final opts = ['afuera.mp3', 'miratecomo.mp3', 'mejora.mp3'];
        await play(opts[Random().nextInt(opts.length)]);
      }
    }
  }

  static void dispose() {
    _completionSub?.cancel();
    _player.dispose();
  }
}
