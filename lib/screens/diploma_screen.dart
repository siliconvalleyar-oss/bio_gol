import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:biogol/app_theme.dart';
import 'package:biogol/model/data.dart' as data;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiplomaScreen extends StatefulWidget {
  const DiplomaScreen({super.key});
  @override
  State<DiplomaScreen> createState() => _DiplomaScreenState();
}

class _DiplomaScreenState extends State<DiplomaScreen> {
  List<data.Usuario> _usuarios = [];
  data.Usuario? _seleccionado;

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('usuarios') ?? '[]';
    final list = (json.decode(raw) as List).map((e) =>
      data.Usuario.fromJson(e as Map<String, dynamic>)).toList();
    list.sort((a, b) => b.puntosTotales.compareTo(a.puntosTotales));
    if (mounted) {
      setState(() {
        _usuarios = list.where((u) => u.puntosTotales > 0).toList();
        if (_usuarios.isNotEmpty) _seleccionado = _usuarios.first;
      });
    }
  }

  bool get _esCampeon =>
    _seleccionado != null &&
    _seleccionado!.puntos > 0 &&
    _seleccionado!.reaccionPromedio > 0 &&
    _seleccionado!.colorTestPuntos > 0 &&
    _seleccionado!.sonidoTestPuntos > 0;

  String get _qrData {
    if (_seleccionado == null) return '';
    final u = _seleccionado!;
    final buf = StringBuffer();
    buf.writeln('BioGol - Diploma');
    buf.writeln('Nombre: ${u.nombre}');
    buf.writeln('Alias: ${u.alias}');
    buf.writeln('Edad: ${u.edad}');
    buf.writeln('Email: ${u.email}');
    buf.writeln('Teléfono: ${u.telefono}');
    buf.writeln('País: ${u.paisDisplay}');
    buf.writeln('Puntos Trivia: ${u.puntos}');
    buf.writeln('Puntos Colores: ${u.colorTestPuntos}');
    buf.writeln('Puntos Sonidos: ${u.sonidoTestPuntos}');
    buf.writeln('Puntos Totales: ${u.puntosTotales}');
    buf.writeln('Aciertos: ${u.aciertos}');
    buf.writeln('Racha: ${u.racha}');
    buf.writeln('Reacción: ${u.reaccionPromedio} ms');
    buf.writeln('Fecha: ${u.fecha}');
    return buf.toString();
  }

  String get _shareText {
    if (_seleccionado == null) return '';
    final u = _seleccionado!;
    final champion = _esCampeon ? '🏆 ¡CAMPEÓN DE LOS ESTÍMULOS! 🏆\n' : '';
    return '''$champion
🎓 BioGol - Diploma
👤 ${u.nombre} ${u.alias.isNotEmpty ? "(${u.alias})" : ''}
🌍 ${u.paisDisplay}
⭐ Puntos Totales: ${u.puntosTotales}
📝 Trivia: ${u.puntos} pts
🎨 Colores: ${u.colorTestPuntos} pts
🎵 Sonidos: ${u.sonidoTestPuntos} pts
⚡ Reacción: ${u.reaccionPromedio} ms
📅 ${u.fecha.substring(0, 10)}
---
EEST6 · Biología 2026''';
  }

  void _compartirWhatsApp() {
    Share.share(_shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      appBar: AppBar(title: const Text('Diploma')),
      body: _usuarios.isEmpty
          ? const Center(child: Text('No hay usuarios con puntaje.',
              style: TextStyle(color: AppTheme.deactivatedText)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSelector(),
                  const SizedBox(height: 16),
                  if (_esCampeon) _buildChampionBadge(),
                  if (_esCampeon) const SizedBox(height: 16),
                  _buildDiploma(),
                ],
              ),
            ),
    );
  }

  Widget _buildSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: AppTheme.card,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<data.Usuario>(
          value: _seleccionado,
          isExpanded: true,
          hint: const Text('Seleccioná un jugador'),
          items: _usuarios.map((u) => DropdownMenuItem(
            value: u,
            child: Text('${u.nombre} — ${u.puntosTotales} pts'),
          )).toList(),
          onChanged: (v) => setState(() => _seleccionado = v),
        ),
      ),
    );
  }

  Widget _buildChampionBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.emoji_events, size: 48, color: Colors.white),
          SizedBox(height: 8),
          Text('🏆 Campeón de los Estímulos 🏆',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
          Text('Completaste todos los desafíos sensoriales',
            style: TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildDiploma() {
    final u = _seleccionado!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _esCampeon ? const Color(0xFFFFD700) : AppTheme.primary.withValues(alpha: 0.3),
          width: _esCampeon ? 3 : 2,
        ),
      ),
      child: Column(
        children: [
          Text('EEST6 · 2026', style: AppTheme.title.copyWith(
            color: _esCampeon ? const Color(0xFFFFA000) : AppTheme.primary)),
          const SizedBox(height: 6),
          Text(_esCampeon
            ? 'Campeón de los Estímulos'
            : 'Experto en Sistema Nervioso',
            style: AppTheme.headline.copyWith(
              color: AppTheme.darkText, fontSize: 22)),
          const SizedBox(height: 16),
          Text(u.nombre, style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600,
            color: AppTheme.darkText)),
          if (u.alias.isNotEmpty)
            Text(u.alias, style: AppTheme.subtitle),
          Text('${u.edad} años  ·  ${u.paisDisplay}',
            style: AppTheme.caption),
          if (u.email.isNotEmpty)
            Text(u.email, style: AppTheme.caption),
          if (u.telefono.isNotEmpty)
            Text(u.telefono, style: AppTheme.caption),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: AppTheme.cardFlat,
            child: Column(
              children: [
                Text('${u.puntosTotales}', style: AppTheme.headline.copyWith(
                  color: _esCampeon ? const Color(0xFFFFA000) : AppTheme.primary,
                  fontSize: 28)),
                const Text('Puntos totales', style: AppTheme.caption),
                const SizedBox(height: 4),
                Text('Trivia: ${u.puntos}  ·  Colores: ${u.colorTestPuntos}  ·  Sonidos: ${u.sonidoTestPuntos}',
                  style: AppTheme.body2),
                const SizedBox(height: 2),
                Text('${u.aciertos} aciertos  ·  racha ${u.racha}',
                  style: AppTheme.body2),
                if (u.reaccionPromedio > 0)
                  Text('Reacción: ${u.reaccionPromedio} ms',
                    style: AppTheme.caption),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _esCampeon
              ? _campeonText
              : '${u.nombre} demostró sus conocimientos sobre la función de relación, estímulos y el sistema nervioso aplicado al fútbol.',
            textAlign: TextAlign.center,
            style: AppTheme.body2.copyWith(color: AppTheme.lightText),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: QrImageView(
              data: _qrData,
              version: QrVersions.auto,
              size: 120,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text('Escané para ver los datos',
            style: AppTheme.caption),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _compartirWhatsApp,
              icon: const Icon(Icons.share, size: 16),
              label: const Text('Compartir'),
              style: AppTheme.minimalButton,
            ),
          ),
          const SizedBox(height: 16),
          Text('EEST6 · Proyecto Anual Biología 2026',
            style: AppTheme.caption),
        ],
      ),
    );
  }
}

const _campeonText = 'Este jugador completó todos los desafíos sensoriales: '
    'Trivia, Reacción, Colores y Sonidos. '
    'Demostrando un dominio completo del sistema nervioso aplicado al fútbol. '
    '¡Campeón de los Estímulos!';
