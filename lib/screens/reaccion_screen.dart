import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biogol/app_theme.dart';

class ReaccionScreen extends StatefulWidget {
  const ReaccionScreen({super.key});
  @override
  State<ReaccionScreen> createState() => _ReaccionScreenState();
}

enum ReaccionState { idle, waiting, ready, go, result }

class _ReaccionScreenState extends State<ReaccionScreen> {
  ReaccionState _rState = ReaccionState.idle;
  final List<int> _times = [];
  int _count = 0;
  int _errores = 0;
  int _startTime = 0;
  Color _bgColor = AppTheme.grayLight;
  String _texto = 'Presioná Iniciar';
  int? _lastTime;
  String _perf = '';
  bool _completado = false;

  void _startTest() {
    if (_rState == ReaccionState.result || _rState == ReaccionState.idle) {
      if (_count >= 6) {
        _completado = true;
        setState(() {});
        return;
      }
      setState(() {
        _rState = ReaccionState.waiting;
        _bgColor = AppTheme.grayLight;
        _texto = 'Esperá la señal...';
        _lastTime = null;
      });
      final delay = 1000 + Random().nextInt(3000);
      Future.delayed(Duration(milliseconds: delay), () {
        if (!mounted || _rState != ReaccionState.waiting) return;
        setState(() {
          _rState = ReaccionState.go;
          _bgColor = AppTheme.success;
          _texto = 'TOCÁ AHORA';
        });
        _startTime = DateTime.now().millisecondsSinceEpoch;
      });
    }
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    if (_rState == ReaccionState.go) {
      final t = DateTime.now().millisecondsSinceEpoch - _startTime;
      _times.add(t);
      _count++;
      setState(() {
        _rState = ReaccionState.result;
        _bgColor = AppTheme.grayLight;
        _lastTime = t;
        if (t < 180) { _perf = 'Excelente'; }
        else if (t < 250) { _perf = 'Bueno'; }
        else if (t < 350) { _perf = 'Normal'; }
        else { _perf = 'Lento'; }
        _texto = '$t ms  $_perf';
      });
      if (_count >= 6) {
        _completado = true;
      } else {
        Future.delayed(const Duration(seconds: 1), _startTest);
      }
    } else if (_rState == ReaccionState.waiting) {
      _count++;
      setState(() {
        _rState = ReaccionState.idle;
        _bgColor = AppTheme.errorLight;
        _texto = '¡Presionaste antes de tiempo! Oportunidad perdida.';
        _errores++;
      });
      if (_count >= 6) {
        _completado = true;
      } else {
        Future.delayed(const Duration(seconds: 1), _startTest);
      }
    }
  }

  void _finalizar() {
    Navigator.pop(context, _promedio);
  }

  int get _promedio => _times.isEmpty ? 0 : _times.reduce((a,b)=>a+b) ~/ _times.length;

  @override
  Widget build(BuildContext context) {
    final prom = _promedio;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finalizar();
      },
      child: Scaffold(
        backgroundColor: AppTheme.nearlyWhite,
        appBar: AppBar(
          title: Text(_completado
            ? 'Test de Reacción - Completado'
            : 'Test de Reacción'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _finalizar,
          ),
        ),
        body: _completado ? _buildCompletado(prom) : _buildJuego(prom),
      ),
    );
  }

  Widget _buildCompletado(int prom) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: AppTheme.card,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Test de Reacción', style: AppTheme.headline),
              const SizedBox(height: 8),
              const Text('Completado', style: AppTheme.subtitle),
              const SizedBox(height: 16),
              Icon(Icons.timer, size: 64,
                color: prom < 200 ? AppTheme.success : AppTheme.primary),
              const SizedBox(height: 12),
              Text('$prom ms', style: AppTheme.headline.copyWith(fontSize: 32)),
              Text('Promedio', style: AppTheme.caption),
              const SizedBox(height: 4),
              Text('Oportunidades perdidas: $_errores', style: AppTheme.caption),
              const SizedBox(height: 4),
              Text(
                prom < 180 ? 'Excelente' : prom < 250 ? 'Bueno' : prom < 350 ? 'Normal' : 'Lento',
                style: AppTheme.title.copyWith(
                  color: prom < 250 ? AppTheme.success : AppTheme.warning),
              ),
              const SizedBox(height: 24),
              _buildResultsTable(prom),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJuego(int prom) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: AppTheme.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Test de tiempo de reacción', style: AppTheme.title),
                const SizedBox(height: 4),
                Text('Tocá cuando la pantalla se ponga verde.',
                  style: AppTheme.body2.copyWith(color: AppTheme.lightText)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: _handleTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(_texto, textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _lastTime != null ? 24 : 20,
                      fontWeight: FontWeight.w600,
                      color: _rState == ReaccionState.go
                          ? Colors.white : AppTheme.darkText,
                    )),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _startTest,
              style: AppTheme.minimalPrimary,
              child: const Text('Iniciar'),
            ),
          ),
          const SizedBox(height: 4),
          Text('Oportunidad $_count/6  •  Perdidas: $_errores', style: AppTheme.caption),
          const Spacer(flex: 1),
          const SizedBox(height: 16),
          if (_times.isNotEmpty) ...[
            SizedBox(
              height: 120,
              child: _buildResultsTable(prom),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildResultsTable(int prom) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Resultados', style: AppTheme.title),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(_times.length, (i) {
                  final t = _times[i];
                  final p = t < 180 ? 'Óptimo' : t < 250 ? 'Bueno' : t < 350 ? 'Normal' : 'Lento';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        SizedBox(width: 20, child: Text('${i+1}.',
                          style: AppTheme.body2)),
                        Expanded(child: Text('${t}ms', style: AppTheme.body2)),
                        Text(p, style: AppTheme.caption),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          const Divider(height: 12),
          Row(
            children: [
              const SizedBox(width: 20),
              Text('Promedio:', style: AppTheme.body2.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Text('${prom}ms', style: AppTheme.body2.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                prom < 180 ? 'Óptimo' : prom < 250 ? 'Bueno' : prom < 350 ? 'Normal' : 'Lento',
                style: AppTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
