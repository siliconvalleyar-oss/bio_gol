import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:biogol/app_theme.dart';

class SonidoTestScreen extends StatefulWidget {
  const SonidoTestScreen({super.key});
  @override
  State<SonidoTestScreen> createState() => _SonidoTestScreenState();
}

class _SonidoTestScreenState extends State<SonidoTestScreen> {
  static const _totalRondas = 6;
  int _ronda = 0;
  int _puntos = 0;
  int _aciertos = 0;
  int _errores = 0;
  String _targetTono = '';
  bool _jugando = false;
  bool _audioPlaying = false;
  int? _selectedIdx;
  int _correctIdx = -1;
  bool _terminado = false;
  int _tiempoRestante = 5000;
  Timer? _countdownTimer;
  final Stopwatch _timer = Stopwatch();
  final AudioPlayer _player = AudioPlayer();

  static const _tonos = ['grave', 'media', 'aguda'];
  static const _frecuencias = {'grave': 400, 'media': 1200, 'aguda': 2800};
  static const _descripciones = {
    'grave': 'Grave (bajo)',
    'media': 'Medio',
    'aguda': 'Agudo (alto)',
  };

  @override
  void initState() {
    super.initState();
    _nuevaRonda();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _player.dispose();
    super.dispose();
  }

  void _nuevaRonda() {
    if (_ronda >= _totalRondas) {
      setState(() => _terminado = true);
      return;
    }
    final rng = Random();
    _targetTono = _tonos[rng.nextInt(3)];
    setState(() {
      _jugando = true;
      _selectedIdx = null;
      _correctIdx = _tonos.indexOf(_targetTono);
      _tiempoRestante = 5000;
    });
    _reproducirTono();
    _timer.reset();
    _timer.start();
    _iniciarCountdown();
  }

  void _iniciarCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted || _selectedIdx != null) { t.cancel(); return; }
      final restante = 5000 - _timer.elapsedMilliseconds;
      setState(() => _tiempoRestante = restante.clamp(0, 5000));
      if (restante <= 0) {
        t.cancel();
        _forzarFinRonda();
      }
    });
  }

  void _forzarFinRonda() {
    if (_selectedIdx != null) return;
    setState(() {
      _selectedIdx = -2;
      _errores++;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _player.stop();
        setState(() { _ronda++; _nuevaRonda(); });
      }
    });
  }

  Future<void> _reproducirTono() async {
    if (_audioPlaying) return;
    final freq = _frecuencias[_targetTono] ?? 800;
    final bytes = _generarWav(freq, 1000);
    setState(() => _audioPlaying = true);
    try {
      await _player.stop();
      await _player.play(BytesSource(bytes));
    } catch (_) {}
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) setState(() => _audioPlaying = false);
    });
  }

  Uint8List _generarWav(int freqHz, int durationMs) {
    final sampleRate = 44100;
    final nSamples = sampleRate * durationMs ~/ 1000;
    final data = Int16List(nSamples);
    for (int i = 0; i < nSamples; i++) {
      final t = i / sampleRate;
      double envelope = 1.0;
      final fadeSamples = sampleRate ~/ 50;
      if (i < fadeSamples) envelope = i / fadeSamples;
      else if (i > nSamples - fadeSamples) envelope = (nSamples - i) / fadeSamples;
      data[i] = (envelope * 30000 * sin(2 * pi * freqHz * t)).round();
    }
    final dataSize = nSamples * 2;
    final header = ByteData(44);
    header.setUint8(0, 0x52); header.setUint8(1, 0x49);
    header.setUint8(2, 0x46); header.setUint8(3, 0x46);
    header.setUint32(4, 36 + dataSize, Endian.little);
    header.setUint8(8, 0x57); header.setUint8(9, 0x41);
    header.setUint8(10, 0x56); header.setUint8(11, 0x45);
    header.setUint8(12, 0x66); header.setUint8(13, 0x6D);
    header.setUint8(14, 0x74); header.setUint8(15, 0x20);
    header.setUint32(16, 16, Endian.little);
    header.setUint16(20, 1, Endian.little);
    header.setUint16(22, 1, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, sampleRate * 2, Endian.little);
    header.setUint16(32, 2, Endian.little);
    header.setUint16(34, 16, Endian.little);
    header.setUint8(36, 0x64); header.setUint8(37, 0x61);
    header.setUint8(38, 0x74); header.setUint8(39, 0x61);
    header.setUint32(40, dataSize, Endian.little);
    final result = Uint8List(44 + dataSize);
    result.setRange(0, 44, header.buffer.asUint8List());
    result.setRange(44, 44 + dataSize, data.buffer.asUint8List());
    return result;
  }

  void _seleccionar(int idx) {
    if (_selectedIdx != null || !_jugando) return;
    _countdownTimer?.cancel();
    _timer.stop();
    final ms = _timer.elapsedMilliseconds;
    final correcta = idx == _correctIdx;
    final pts = correcta ? max(1, 10 - ((ms - 1) ~/ 100)) : 0;
    setState(() {
      _selectedIdx = idx;
      _puntos += pts;
      if (correcta) _aciertos++; else _errores++;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) { _player.stop(); setState(() { _ronda++; _nuevaRonda(); }); }
    });
  }

  void _finalizar() {
    _countdownTimer?.cancel();
    _player.stop();
    Navigator.pop(context, _puntos);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) { if (!didPop) _finalizar(); },
      child: Scaffold(
        backgroundColor: AppTheme.nearlyWhite,
        appBar: AppBar(
          title: Text(_terminado ? 'Test de Sonidos - Completado'
            : 'Test de Sonidos — Ronda ${_ronda + 1}/$_totalRondas'),
          leading: IconButton(icon: const Icon(Icons.close), onPressed: _finalizar),
        ),
        body: _terminado ? _buildResultado() : _buildJuego(),
      ),
    );
  }

  Widget _buildResultado() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24), padding: const EdgeInsets.all(32),
        decoration: AppTheme.card,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Test de Sonidos', style: AppTheme.headline),
          const SizedBox(height: 8),
          const Text('Completado', style: AppTheme.subtitle),
          const SizedBox(height: 16),
          Icon(_aciertos >= 5 ? Icons.emoji_events : Icons.music_note,
            size: 64, color: _aciertos >= 5 ? AppTheme.warning : AppTheme.primary),
          const SizedBox(height: 12),
          Text('$_aciertos aciertos', style: AppTheme.title),
          Text('$_errores errores', style: AppTheme.caption),
          const SizedBox(height: 4),
          Text('$_puntos puntos', style: AppTheme.headline.copyWith(
            color: _puntos >= 0 ? AppTheme.success : AppTheme.error)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _finalizar,
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Finalizar test'),
              style: AppTheme.minimalPrimary,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildJuego() {
    final freq = _frecuencias[_targetTono] ?? 800;
    final pct = _tiempoRestante / 5000;
    final segs = (_tiempoRestante / 1000).toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct.clamp(0.0, 1.0), minHeight: 8,
              backgroundColor: AppTheme.grayLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                _tiempoRestante > 3000 ? AppTheme.success
                    : _tiempoRestante > 1500 ? AppTheme.warning : AppTheme.error),
            ),
          ),
          const SizedBox(height: 4),
          Text('${segs}s', style: AppTheme.caption.copyWith(
            color: _tiempoRestante < 1500 ? AppTheme.error : AppTheme.lightText,
            fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _selectedIdx == null ? _reproducirTono : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 140, height: 140,
              decoration: BoxDecoration(
                color: AppTheme.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _audioPlaying ? AppTheme.primary
                      : (_selectedIdx != null
                          ? (_selectedIdx == _correctIdx ? AppTheme.success : AppTheme.error)
                          : AppTheme.border),
                  width: 3,
                ),
              ),
              child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _audioPlaying ? Icons.volume_up : Icons.graphic_eq,
                    key: ValueKey(_audioPlaying),
                    size: 40,
                    color: _audioPlaying ? AppTheme.primary : AppTheme.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                if (_audioPlaying)
                  const Text('Reproduciendo...', style: TextStyle(color: AppTheme.primary, fontSize: 11))
                else if (_selectedIdx == null)
                  const Text('Tocar para oír', style: TextStyle(color: AppTheme.primary, fontSize: 11))
                else
                  Text('$freq Hz',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: _selectedIdx != null
                          ? (_selectedIdx == _correctIdx ? AppTheme.success : AppTheme.error)
                          : AppTheme.darkText)),
              ])),
            ),
          ),
          const SizedBox(height: 12),
          Text('Identificá el tono:', style: AppTheme.subtitle),
          const SizedBox(height: 4),
          Text('Puntos: $_puntos  •  $_ronda/$_totalRondas', style: AppTheme.caption),
          const SizedBox(height: 8),
          _buildOption(0, _descripciones['grave']!, Icons.trending_down, Colors.red.shade300),
          const SizedBox(height: 8),
          _buildOption(1, _descripciones['media']!, Icons.remove, Colors.blue.shade300),
          const SizedBox(height: 8),
          _buildOption(2, _descripciones['aguda']!, Icons.trending_up, Colors.green.shade300),
        ],
      ),
    );
  }

  Widget _buildOption(int idx, String label, IconData icon, Color color) {
    final selected = _selectedIdx == idx;
    final correct = idx == _correctIdx;
    return GestureDetector(
      onTap: () => _seleccionar(idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? (correct ? AppTheme.successLight : AppTheme.errorLight)
              : AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? (correct ? AppTheme.success : AppTheme.error)
                : AppTheme.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 10),
          Text(label, style: AppTheme.title),
          if (selected) ...[
            const Spacer(),
            Icon(correct ? Icons.check_circle : Icons.cancel,
              color: correct ? AppTheme.success : AppTheme.error, size: 20),
          ],
        ]),
      ),
    );
  }
}
