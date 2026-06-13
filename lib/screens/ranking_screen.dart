import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:biogol/app_theme.dart';
import 'package:biogol/model/data.dart' as data;
import 'package:shared_preferences/shared_preferences.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});
  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<data.Usuario> _usuarios = [];
  String? _activeUserId;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('usuarios') ?? '[]';
    final list = (json.decode(raw) as List).map((e) =>
      data.Usuario.fromJson(e as Map<String, dynamic>)).toList();
    list.sort((a, b) => b.puntosTotales.compareTo(a.puntosTotales));
    final uid = prefs.getString('usuarioActivoId') ?? '';
    if (mounted) {
      setState(() {
        _usuarios = list;
        _activeUserId = uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      appBar: AppBar(title: const Text('Ranking')),
      body: _usuarios.isEmpty
          ? const Center(child: Text('No hay usuarios registrados.',
              style: TextStyle(color: AppTheme.deactivatedText)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _usuarios.length + 1,
              itemBuilder: (_, index) {
                if (index == 0) return _buildHeader();
                final u = _usuarios[index - 1];
                final isActive = u.id == _activeUserId;
                final rank = index;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: AppTheme.card.copyWith(
                    border: Border.all(
                      color: isActive ? AppTheme.primary : AppTheme.border,
                      width: isActive ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: SizedBox(
                      width: 36,
                      child: Text('#$rank',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: rank <= 3 ? AppTheme.warning : AppTheme.lightText,
                        )),
                    ),
                    title: Text(u.nombre,
                      style: TextStyle(
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      )),
                    subtitle: Text([
                      if (u.alias.isNotEmpty) u.alias,
                      u.paisDisplay,
                      '${u.edad} años',
                    ].join('  ·  '), style: AppTheme.caption),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${u.puntosTotales}', style: AppTheme.title.copyWith(
                          color: AppTheme.primary)),
                        Text('pts', style: AppTheme.caption),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_usuarios.length} jugadores',
                  style: AppTheme.title),
                const Text('Ordenados por puntos totales',
                  style: AppTheme.caption),
              ],
            ),
          ),
          Icon(Icons.emoji_events, color: AppTheme.warning, size: 32),
        ],
      ),
    );
  }
}
