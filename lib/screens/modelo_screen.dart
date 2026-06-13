import 'package:flutter/material.dart';
import 'package:biogol/app_theme.dart';
import 'package:biogol/model/data.dart' as data;
import 'package:biogol/services/audio_service.dart';

class ModeloScreen extends StatefulWidget {
  const ModeloScreen({super.key});
  @override
  State<ModeloScreen> createState() => _ModeloScreenState();
}

class _ModeloScreenState extends State<ModeloScreen>
    with SingleTickerProviderStateMixin {
  int? _selectedStep;
  List<String> _penalPasos = [];
  bool _reproduciendo = false;
  int _activePaso = -1;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _reproducirPenal() {
    if (_reproduciendo) return;
    final pasos = [
      "Estímulo: El delantero ve el arco libre",
      "Receptor: Sus ojos captan la imagen",
      "Procesamiento: El cerebro calcula distancia y ángulo",
      "Efector: Los músculos de la pierna se activan",
      "Respuesta: Patea al arco y ¡GOL!",
    ];
    final audioFiles = [
      'paso1_estimulo.mp3',
      'paso2_receptor.mp3',
      'paso3_procesamiento.mp3',
      'paso4_efector.mp3',
      'paso5_respuesta.mp3',
    ];
    setState(() {
      _reproduciendo = true;
      _penalPasos = [];
      _activePaso = -1;
    });
    _reproduciPaso(0, pasos, audioFiles);
  }

  Future<void> _reproduciPaso(
      int i, List<String> pasos, List<String> audioFiles) async {
    if (!mounted || i >= pasos.length) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() {
          _reproduciendo = false;
          _activePaso = -1;
        });
        _pulseCtrl.reset();
      }
      return;
    }
    if (mounted) {
      setState(() => _activePaso = i);
      _pulseCtrl.repeat(reverse: true);
    }
    if (i < audioFiles.length) {
      await AudioService.play(audioFiles[i]);
    }
    if (!mounted) return;
    setState(() => _penalPasos.add(pasos[i]));
    _reproduciPaso(i + 1, pasos, audioFiles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      appBar: AppBar(title: const Text('Modelo E-R-P-R-E')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModeloFlow(),
            const SizedBox(height: 12),
            _buildInfoCard(),
            const SizedBox(height: 12),
            _buildPenalCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildModeloFlow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Modelo E-R-P-R-E', style: AppTheme.title),
          const SizedBox(height: 4),
          Text('Tocá cada paso para explorar cómo reacciona tu cuerpo ante una jugada.',
            style: AppTheme.body2.copyWith(color: AppTheme.lightText)),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(data.InfoModelo.pasos.length, (i) {
                final p = data.InfoModelo.pasos[i];
                final isActive = _activePaso == i;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (i > 0) Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.arrow_forward_ios, size: 14,
                        color: AppTheme.deactivatedText),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _selectedStep = i),
                      child: AnimatedBuilder(
                        animation: _pulseCtrl,
                        builder: (context, child) {
                          final scale = isActive
                              ? 1.0 + _pulseCtrl.value * 0.15
                              : 1.0;
                          return Transform.scale(
                            scale: scale,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: p.color.withValues(alpha: 0.85),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isActive || _selectedStep == i
                                        ? p.color : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(p.titulo.split(' ')[0],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      )),
                                  ),
                                ),
                              ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    if (_selectedStep == null) return const SizedBox();
    final p = data.InfoModelo.pasos[_selectedStep!];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardFlat,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.icono, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.titulo, style: AppTheme.title),
                const SizedBox(height: 4),
                Text(p.descripcion, style: AppTheme.body2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ejemplo interactivo: El penal', style: AppTheme.title),
          const SizedBox(height: 4),
          Text('Presioná para ver la secuencia completa:',
            style: AppTheme.body2.copyWith(color: AppTheme.lightText)),
          const SizedBox(height: 12),
          ..._penalPasos.map((p) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.grayLight,
              borderRadius: BorderRadius.circular(6),
              border: Border(left: BorderSide(color: AppTheme.primary, width: 2)),
            ),
            child: Row(
              children: [
                Expanded(child: Text(p, style: AppTheme.body2)),
              ],
            ),
          )),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _reproduciendo ? null : _reproducirPenal,
            icon: Icon(
              _reproduciendo ? Icons.hourglass_top : Icons.play_arrow_rounded,
              size: 18,
            ),
            label: Text(
              _reproduciendo ? 'Reproduciendo...' : 'Reproducir',
              style: const TextStyle(fontSize: 13),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.gray,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: AppTheme.border),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
