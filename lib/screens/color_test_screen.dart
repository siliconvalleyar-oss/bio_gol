import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:biogol/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorTestScreen extends StatefulWidget {
  const ColorTestScreen({super.key});
  @override
  State<ColorTestScreen> createState() => _ColorTestScreenState();
}

class _ColorTestScreenState extends State<ColorTestScreen> {
  static const _totalRondas = 10;
  int _ronda = 0;
  int _puntos = 0;
  bool _mostrando = false;
  Color _targetColor = Colors.transparent;
  List<Color> _opciones = [];
  int? _selectedIndex;
  int? _correctIndex;
  bool _terminado = false;
  int _aciertos = 0;
  int _errores = 0;
  bool _preparando = true;
  int _duracionMs = 300;
  int _tiempoRestante = 5000;
  Timer? _countdownTimer;
  final Stopwatch _timer = Stopwatch();

  static const List<Color> _paleta = [
    Colors.red, Colors.blue, Colors.green, Colors.yellow,
    Colors.orange, Colors.purple, Colors.cyan, Colors.pink,
  ];

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
    _duracionMs = (prefs.getDouble('colorDuracionMs') ?? 300).round();
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
    final targetIdx = rng.nextInt(_paleta.length);
    _targetColor = _paleta[targetIdx];
    final opcs = <Color>[_targetColor];
    while (opcs.length < 4) {
      final c = _paleta[rng.nextInt(_paleta.length)];
      if (!opcs.contains(c)) opcs.add(c);
    }
    opcs.shuffle(rng);
    final correctIdx = opcs.indexOf(_targetColor);
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
          title: Text(_preparando ? 'Test de Colores'
            : _terminado ? 'Test de Colores - Completado'
            : 'Test de Colores — Ronda ${_ronda + 1}/$_totalRondas'),
          leading: IconButton(icon: const Icon(Icons.close), onPressed: _salir),
        ),
        body: _preparando ? _buildPreparando()
            : (_terminado ? _buildResultado() : _buildJuego()),
      ),
    );
  }

  Widget _buildPreparando() {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.palette, size: 64, color: AppTheme.primary),
      const SizedBox(height: 16),
      const Text('Preparando test...', style: AppTheme.headline),
      const SizedBox(height: 8),
      const Text('Mirá atentamente el color que aparece', style: AppTheme.subtitle),
      const SizedBox(height: 24),
      const CircularProgressIndicator(color: AppTheme.primary),
    ]));
  }

  Widget _buildResultado() {
    return Center(child: Container(
      margin: const EdgeInsets.all(24), padding: const EdgeInsets.all(32),
      decoration: AppTheme.card,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Test de Colores', style: AppTheme.headline),
        const SizedBox(height: 8),
        const Text('Completado', style: AppTheme.subtitle),
        const SizedBox(height: 16),
        Icon(_aciertos >= 7 ? Icons.emoji_events : Icons.palette,
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
            width: 140, height: 140,
            decoration: BoxDecoration(
              color: _targetColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border, width: 2),
            ),
            child: const Center(child: Text('¿?', style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white54))),
          )
        else
          Container(
            width: 140, height: 140,
            decoration: BoxDecoration(
              color: AppTheme.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border, width: 2),
            ),
            child: const Center(child: Text('¿Qué color viste?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppTheme.deactivatedText))),
          ),
        const SizedBox(height: 8),
        Text('Puntos: $_puntos  •  Aciertos: $_aciertos', style: AppTheme.caption),
        const SizedBox(height: 8),
        Expanded(
          child: GridView(
            padding: const EdgeInsets.all(8),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
              childAspectRatio: 1.8,
            ),
            children: List.generate(4, (idx) => _buildColorOption(idx)),
          ),
        ),
      ]),
    );
  }

  Widget _buildColorOption(int idx) {
    final color = _opciones[idx];
    final selected = _selectedIndex == idx;
    final correct = _correctIndex == idx;
    return GestureDetector(
      onTap: () => _seleccionar(idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
        child: Center(child: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: color, shape: BoxShape.circle,
            border: Border.all(color: AppTheme.border),
          ),
        )),
      ),
    );
  }
}
