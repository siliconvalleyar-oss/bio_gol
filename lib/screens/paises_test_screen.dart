import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:biogol/app_theme.dart';
import 'package:biogol/model/data.dart' as data;
import 'package:shared_preferences/shared_preferences.dart';

class PaisesTestScreen extends StatefulWidget {
  const PaisesTestScreen({super.key});
  @override
  State<PaisesTestScreen> createState() => _PaisesTestScreenState();
}

class _PaisesTestScreenState extends State<PaisesTestScreen> {
  static const _totalRondas = 10;
  int _ronda = 0;
  int _puntos = 0;
  bool _mostrando = false;
  data.PaisInfo _targetPais = const data.PaisInfo('', '');
  List<data.PaisInfo> _opciones = [];
  int? _selectedIndex;
  int? _correctIndex;
  bool _terminado = false;
  int _aciertos = 0;
  int _errores = 0;
  bool _preparando = true;
  int _duracionMs = 200;
  int _tiempoRestante = 5000;
  Timer? _countdownTimer;
  final Stopwatch _timer = Stopwatch();

  @override
  void initState() {
    super.initState();
    _cargarDuracion();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _cargarDuracion() async {
    final prefs = await SharedPreferences.getInstance();
    _duracionMs = (prefs.getDouble('paisDuracionMs') ?? 200).round();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _preparando = false);
        _nuevaRonda();
      }
    });
  }

  void _nuevaRonda() {
    if (_ronda >= _totalRondas) {
      setState(() => _terminado = true);
      return;
    }
    final rng = Random();
    final paises = List<data.PaisInfo>.from(data.PaisInfo.lista);
    paises.shuffle(rng);
    _targetPais = paises.first;
    final opcs = <data.PaisInfo>[_targetPais];
    for (final p in paises) {
      if (opcs.length >= 4) break;
      if (!opcs.any((o) => o.nombre == p.nombre)) opcs.add(p);
    }
    opcs.shuffle(rng);
    final correctIdx = opcs.indexWhere((o) => o.nombre == _targetPais.nombre);
    setState(() {
      _opciones = opcs;
      _correctIndex = correctIdx;
      _selectedIndex = null;
      _mostrando = true;
      _tiempoRestante = 5000;
    });
    _timer.reset();
    _timer.start();
    Future.delayed(Duration(milliseconds: _duracionMs), () {
      if (mounted) setState(() => _mostrando = false);
    });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted || _selectedIndex != null) { t.cancel(); return; }
      final restante = 5000 - _timer.elapsedMilliseconds;
      setState(() => _tiempoRestante = restante.clamp(0, 5000));
      if (restante <= 0) {
        t.cancel();
        _forzarFinRonda();
      }
    });
  }

  void _forzarFinRonda() {
    if (_selectedIndex != null) return;
    setState(() {
      _selectedIndex = -2;
      _errores++;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) { setState(() { _ronda++; _nuevaRonda(); }); }
    });
  }

  void _seleccionar(int idx) {
    if (_selectedIndex != null || _mostrando || _preparando) return;
    _countdownTimer?.cancel();
    _timer.stop();
    final segsRestantes = _tiempoRestante ~/ 1000;
    final correcta = idx == _correctIndex;
    final pts = correcta ? segsRestantes : 0;
    setState(() {
      _selectedIndex = idx;
      _puntos += pts;
      if (correcta) _aciertos++; else _errores++;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) { setState(() { _ronda++; _nuevaRonda(); }); }
    });
  }

  void _salir() {
    _countdownTimer?.cancel();
    Navigator.pop(context, _puntos);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) { if (!didPop) _salir(); },
      child: Scaffold(
        backgroundColor: AppTheme.nearlyWhite,
        appBar: AppBar(
          title: Text(_preparando ? 'Test de Países'
            : _terminado ? 'Test de Países - Completado'
            : 'Test de Países — Ronda ${_ronda + 1}/$_totalRondas'),
          leading: IconButton(icon: const Icon(Icons.close), onPressed: _salir),
        ),
        body: _preparando ? _buildPreparando()
            : (_terminado ? _buildResultado() : _buildJuego()),
      ),
    );
  }

  Widget _buildPreparando() {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.flag, size: 64, color: AppTheme.primary),
      const SizedBox(height: 16),
      const Text('Preparando test...', style: AppTheme.headline),
      const SizedBox(height: 8),
      const Text('Mirá atentamente la bandera que aparece', style: AppTheme.subtitle),
      const SizedBox(height: 24),
      const CircularProgressIndicator(color: AppTheme.primary),
    ]));
  }

  Widget _buildResultado() {
    return Center(child: Container(
      margin: const EdgeInsets.all(24), padding: const EdgeInsets.all(32),
      decoration: AppTheme.card,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Test de Países', style: AppTheme.headline),
        const SizedBox(height: 8),
        const Text('Completado', style: AppTheme.subtitle),
        const SizedBox(height: 16),
        Icon(_aciertos >= 7 ? Icons.emoji_events : Icons.flag,
          size: 64, color: _aciertos >= 7 ? AppTheme.warning : AppTheme.primary),
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
            onPressed: _salir,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Finalizar test'),
            style: AppTheme.minimalPrimary,
          ),
        ),
      ]),
    ));
  }

  Widget _buildJuego() {
    final pct = _tiempoRestante / 5000;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        const SizedBox(height: 8),
        if (!_mostrando) ...[
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
          Text('${_tiempoRestante ~/ 1000}s', style: AppTheme.caption.copyWith(
            color: _tiempoRestante < 1500 ? AppTheme.error : AppTheme.lightText,
            fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
        ],
        if (_mostrando)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 160, height: 100,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border, width: 2),
            ),
            child: Center(child: Text(_targetPais.flag, style: const TextStyle(fontSize: 64))),
          )
        else
          Container(
            width: 160, height: 100,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border, width: 2),
            ),
            child: const Center(child: Text('¿Qué país viste?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppTheme.deactivatedText))),
          ),
        const SizedBox(height: 8),
        Text('Puntos: $_puntos  •  Aciertos: $_aciertos', style: AppTheme.caption),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _opciones.length,
            itemBuilder: (_, idx) => _buildPaisOption(idx),
          ),
        ),
      ]),
    );
  }

  Widget _buildPaisOption(int idx) {
    final pais = _opciones[idx];
    final selected = _selectedIndex == idx;
    final correct = _correctIndex == idx;
    return GestureDetector(
      onTap: () => _seleccionar(idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          Text(pais.flag, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          Text(pais.nombre, style: AppTheme.title),
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
