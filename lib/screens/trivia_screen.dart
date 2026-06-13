import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biogol/app_theme.dart';
import 'package:biogol/model/data.dart' as data;
import 'package:biogol/services/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TriviaResult {
  final int puntos;
  final int correctas;
  final int incorrectas;
  final int rachaMax;
  TriviaResult(this.puntos, this.correctas, this.incorrectas, this.rachaMax);
}

class TriviaScreen extends StatefulWidget {
  final bool demo;
  const TriviaScreen({super.key, this.demo = false});
  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  int _index = 0;
  int _correctas = 0;
  int _incorrectas = 0;
  int _puntosTrivia = 0;
  int _racha = 0;
  int _rachaMax = 0;
  bool _answered = false;
  bool? _selectedResp;
  int _segundos = 10;
  int _segundosMax = 10;
  double _fontSize = 15;
  Timer? _timer;

  late List<data.PreguntaTrivia> _preguntas;

  @override
  void initState() {
    super.initState();
    _preguntas = List.from(
      widget.demo ? data.PreguntaTrivia.demo : data.PreguntaTrivia.lista);
    if (!widget.demo) {
      _preguntas.shuffle();
      if (_preguntas.length > 16) _preguntas = _preguntas.sublist(0, 16);
    }
    _cargarInicio();
  }

  Future<void> _cargarInicio() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final t = widget.demo ? 20.0 : (prefs.getDouble('timerSegundos') ?? 10);
    final f = prefs.getDouble('fontSize') ?? 15;
    setState(() {
      _segundos = t.round();
      _segundosMax = t.round();
      _fontSize = f;
    });
    _iniciarTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _iniciarTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_segundos <= 1) {
        _timer?.cancel();
        _responder(null, null);
      } else {
        setState(() => _segundos--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_index >= _preguntas.length) {
      return _buildResult();
    }
    final q = _preguntas[_index];
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      appBar: AppBar(
        title: Text(widget.demo ? 'Trivia Demo' : 'Trivia'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildScoreBar(),
            const SizedBox(height: 16),
            Expanded(child: _buildQuestionCard(q)),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: AppTheme.cardFlat,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${_index + 1}/${_preguntas.length}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Row(
            children: [
              Text('$_puntosTrivia pts',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(width: 12),
              Text('$_correctas',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13,
                  color: AppTheme.success)),
              const SizedBox(width: 4),
              Text('$_incorrectas',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13,
                  color: AppTheme.error)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    final frac = _segundosMax > 0 ? _segundos / _segundosMax : 0.0;
    final color = frac > 0.5 ? AppTheme.success :
                 frac > 0.25 ? AppTheme.warning : AppTheme.error;
    return SizedBox(
      width: 28, height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: frac,
            strokeWidth: 3,
            backgroundColor: AppTheme.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Text('$_segundos', style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(data.PreguntaTrivia q) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Pregunta ${_index + 1}',
                style: AppTheme.subtitle.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              _buildTimer(),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Text(q.texto, style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: _fontSize,
                color: AppTheme.darkText)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildAnswerButton(true, q)),
              const SizedBox(width: 10),
              Expanded(child: _buildAnswerButton(false, q)),
            ],
          ),
          Expanded(
            flex: 1,
            child: _answered
                ? Center(
                    child: Text(
                      _selectedResp == q.correcta ? 'Correcto' : 'Incorrecto',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600,
                        color: _selectedResp == q.correcta
                            ? AppTheme.success : AppTheme.error,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(bool valor, data.PreguntaTrivia q) {
    final isSelected = _answered;
    final isCorrect = valor == q.correcta;
    Color bg = AppTheme.white;
    Color borderColor = AppTheme.border;
    if (isSelected) {
      if (isCorrect) { bg = AppTheme.successLight; borderColor = AppTheme.success; }
      else { bg = AppTheme.errorLight; borderColor = AppTheme.error; }
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _answered ? null : () => _responder(valor, q),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Center(
            child: Text(valor ? 'Verdadero' : 'Falso',
              style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14,
                color: isSelected
                    ? (isCorrect ? AppTheme.success : AppTheme.error)
                    : AppTheme.darkText,
              )),
          ),
        ),
      ),
    );
  }

  void _responder(bool? resp, data.PreguntaTrivia? q) {
    if (_answered) return;
    _timer?.cancel();
    if (resp == null || q == null) {
      setState(() {
        _answered = true;
        _selectedResp = null;
        _incorrectas++;
        _racha = 0;
      });
      HapticFeedback.heavyImpact();
      AudioService.feedback(correcta: false, racha: _racha,
        totalPreguntas: _preguntas.length, correctas: _correctas);
      Future.delayed(const Duration(milliseconds: 1200), _siguiente);
      return;
    }
    final correcto = resp == q.correcta;
    final pts = correcto ? _segundos : 0;
    if (!correcto) HapticFeedback.heavyImpact();
    setState(() {
      _answered = true;
      _selectedResp = resp;
      _puntosTrivia += pts;
      if (correcto) {
        _correctas++;
        _racha++;
        if (_racha > _rachaMax) _rachaMax = _racha;
      } else {
        _incorrectas++;
        _racha = 0;
      }
    });
    AudioService.feedback(
      correcta: correcto, racha: _racha,
      totalPreguntas: _preguntas.length, correctas: _correctas,
    );
    Future.delayed(const Duration(milliseconds: 1200), _siguiente);
  }

  void _siguiente() async {
    if (!mounted) return;
    setState(() {
      _index++;
      _answered = false;
      _selectedResp = null;
    });
    if (_index < _preguntas.length) {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      final t = widget.demo ? 20.0 : (prefs.getDouble('timerSegundos') ?? 10);
      setState(() {
        _segundos = t.round();
        _segundosMax = t.round();
      });
      _iniciarTimer();
    }
  }

  Widget _buildResult() {
    final total = _preguntas.length;
    final pct = total > 0 ? (_correctas / total * 100).round() : 0;
    String msg;
    if (pct >= 80) { msg = 'Experto en SN'; }
    else if (pct >= 60) { msg = 'Muy bien'; }
    else { msg = 'Seguí practicando'; }
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      appBar: AppBar(
        title: Text(widget.demo ? 'Trivia Demo' : 'Trivia'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.card,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$pct%', style: AppTheme.headline.copyWith(
                  color: AppTheme.primary)),
                const SizedBox(height: 4),
                Text('$_correctas de $total correctas',
                  style: AppTheme.body1),
                const SizedBox(height: 4),
                Text('$_puntosTrivia pts', style: AppTheme.subtitle),
                const SizedBox(height: 4),
                Text('Racha máxima: $_rachaMax', style: AppTheme.subtitle),
                const SizedBox(height: 4),
                Text(msg, style: AppTheme.subtitle),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, TriviaResult(
                      _puntosTrivia, _correctas, _incorrectas, _rachaMax)),
                    style: AppTheme.minimalPrimary,
                    child: const Text('Finalizar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
