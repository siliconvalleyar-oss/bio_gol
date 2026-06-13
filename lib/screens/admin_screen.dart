import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:biogol/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  double _fontSize = 24;
  String _paletaId = 'default';
  double _timerSegundos = 10;
  double _colorDuracionMs = 300;
  double _paisDuracionMs = 200;
  final List<TextEditingController> _audioCtrls = [];
  final List<_Paleta> _paletas = [
    _Paleta('default', 'Mundial', 'Azules clásicos', const Color(0xFF1565C0)),
    _Paleta('argentina', 'Argentina', 'Celeste y blanco', const Color(0xFF75AADB)),
    _Paleta('brasil', 'Brasil', 'Verde y amarillo', const Color(0xFF1B5E20)),
    _Paleta('noche', 'Noche', 'Modo oscuro', const Color(0xFF1A1A2E)),
    _Paleta('cancha', 'Cancha', 'Verde fútbol', const Color(0xFF33691E)),
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) { _audioCtrls.add(TextEditingController()); }
    _cargar();
  }

  @override
  void dispose() {
    for (final c in _audioCtrls) { c.dispose(); }
    super.dispose();
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 24;
      _paletaId = prefs.getString('paletaId') ?? 'default';
      _timerSegundos = prefs.getDouble('timerSegundos') ?? 10;
      _colorDuracionMs = prefs.getDouble('colorDuracionMs') ?? 300;
      _paisDuracionMs = prefs.getDouble('paisDuracionMs') ?? 200;
      final audioRaw = prefs.getString('audioMap');
      if (audioRaw != null) {
        final list = json.decode(audioRaw) as List;
        for (int i = 0; i < 5 && i < list.length; i++) {
          _audioCtrls[i].text = list[i] as String? ?? '';
        }
      }
    });
  }

  Future<void> _guardarAudio() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _audioCtrls.map((c) => c.text.trim()).toList();
    await prefs.setString('audioMap', json.encode(list));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Configuración de audio guardada'),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      appBar: AppBar(title: const Text('Administración')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPaletasCard(),
            const SizedBox(height: 12),
            _buildFontCard(),
            const SizedBox(height: 12),
            _buildTimerCard(),
            const SizedBox(height: 12),
            _buildColorDuracionCard(),
            const SizedBox(height: 12),
            _buildPaisDuracionCard(),
            const SizedBox(height: 12),
            _buildAudioCard(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: AppTheme.title),
    );
  }

  Widget _buildPaletasCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Paleta de colores'),
          ..._paletas.map((p) => GestureDetector(
            onTap: () => setState(() => _paletaId = p.id),
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _paletaId == p.id
                    ? AppTheme.primaryLight : AppTheme.grayLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _paletaId == p.id ? AppTheme.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: p.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.nombre, style: AppTheme.body1.copyWith(
                          fontWeight: FontWeight.w500)),
                        Text(p.desc, style: AppTheme.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFontCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Tamaño de letra'),
          Row(
            children: [
              const Text('A', style: TextStyle(fontSize: 14, color: AppTheme.lightText)),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 14,
                  max: 36,
                  divisions: 22,
                  activeColor: AppTheme.primary,
                  onChanged: (v) => setState(() => _fontSize = v),
                ),
              ),
              const Text('A', style: TextStyle(fontSize: 28, color: AppTheme.lightText)),
            ],
          ),
          Center(
            child: Text('${_fontSize.round()}px',
              style: AppTheme.caption),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Tiempo de trivia'),
          Text('Segundos para responder:',
            style: AppTheme.body2.copyWith(color: AppTheme.lightText)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('5s', style: TextStyle(fontSize: 14, color: AppTheme.lightText)),
              Expanded(
                child: Slider(
                  value: _timerSegundos,
                  min: 5,
                  max: 30,
                  divisions: 25,
                  activeColor: AppTheme.primary,
                  onChanged: (v) => setState(() => _timerSegundos = v),
                  onChangeEnd: (v) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setDouble('timerSegundos', v);
                  },
                ),
              ),
              const Text('30s', style: TextStyle(fontSize: 14, color: AppTheme.lightText)),
            ],
          ),
          Center(
            child: Text('${_timerSegundos.round()} segundos',
              style: AppTheme.caption),
          ),
        ],
      ),
    );
  }

  Widget _buildColorDuracionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Duración color (test de colores)'),
          Text('Milisegundos que se muestra el color:',
            style: AppTheme.body2.copyWith(color: AppTheme.lightText)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('100ms', style: TextStyle(fontSize: 14, color: AppTheme.lightText)),
              Expanded(
                child: Slider(
                  value: _colorDuracionMs,
                  min: 100,
                  max: 2000,
                  divisions: 19,
                  activeColor: AppTheme.primary,
                  onChanged: (v) => setState(() => _colorDuracionMs = v),
                  onChangeEnd: (v) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setDouble('colorDuracionMs', v);
                  },
                ),
              ),
              const Text('2000ms', style: TextStyle(fontSize: 14, color: AppTheme.lightText)),
            ],
          ),
          Center(
            child: Text('${_colorDuracionMs.round()} ms',
              style: AppTheme.caption),
          ),
        ],
      ),
    );
  }

  Widget _buildPaisDuracionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Duración bandera (test de países)'),
          Text('Milisegundos que se muestra la bandera:',
            style: AppTheme.body2.copyWith(color: AppTheme.lightText)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('50ms', style: TextStyle(fontSize: 14, color: AppTheme.lightText)),
              Expanded(
                child: Slider(
                  value: _paisDuracionMs,
                  min: 50,
                  max: 2000,
                  divisions: 39,
                  activeColor: AppTheme.primary,
                  onChanged: (v) => setState(() => _paisDuracionMs = v),
                  onChangeEnd: (v) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setDouble('paisDuracionMs', v);
                  },
                ),
              ),
              const Text('2000ms', style: TextStyle(fontSize: 14, color: AppTheme.lightText)),
            ],
          ),
          Center(
            child: Text('${_paisDuracionMs.round()} ms',
              style: AppTheme.caption),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioCard() {
    const labels = ['Estímulo', 'Receptor', 'Procesamiento', 'Efector', 'Respuesta'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Audios del penal'),
          Text('Elegí qué audio se reproduce en cada paso:',
            style: AppTheme.body2.copyWith(color: AppTheme.lightText)),
          const SizedBox(height: 10),
          ...List.generate(5, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(labels[i], style: AppTheme.body2.copyWith(
                    fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _audioCtrls[i],
                    decoration: InputDecoration(
                      hintText: 'archivo.mp3',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 4),
          Text('Disponibles: paso1_estimulo.mp3, paso2_receptor.mp3, paso3_procesamiento.mp3, paso4_efector.mp3, paso5_respuesta.mp3, correcto.mp3, incorrecto.mp3',
            style: AppTheme.caption.copyWith(color: AppTheme.lightText)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _guardarAudio,
              style: AppTheme.minimalPrimary,
              child: const Text('Guardar configuración'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Paleta {
  final String id;
  final String nombre;
  final String desc;
  final Color color;
  const _Paleta(this.id, this.nombre, this.desc, this.color);
}
