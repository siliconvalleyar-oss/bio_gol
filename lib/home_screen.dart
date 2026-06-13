import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biogol/app_theme.dart';
import 'package:biogol/model/data.dart';
import 'package:biogol/screens/modelo_screen.dart';
import 'package:biogol/screens/situaciones_screen.dart';
import 'package:biogol/screens/trivia_screen.dart';
import 'package:biogol/screens/reaccion_screen.dart';
import 'package:biogol/screens/color_test_screen.dart';
import 'package:biogol/screens/sonido_test_screen.dart';
import 'package:biogol/screens/paises_test_screen.dart';
import 'package:biogol/screens/circuito_screen.dart';
import 'package:biogol/screens/diploma_screen.dart';
import 'package:biogol/screens/usuarios_screen.dart';
import 'package:biogol/screens/admin_screen.dart';
import 'package:biogol/screens/ranking_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNav = 0;
  final AppState _state = AppState();

  @override
  void initState() {
    super.initState();
    _cargarUsuarioActivo();
  }

  Future<void> _cargarUsuarioActivo() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('usuarios') ?? '[]';
    final list = (json.decode(raw) as List).map((e) =>
      Usuario.fromJson(e as Map<String, dynamic>)).toList();
    final id = prefs.getString('usuarioActivoId') ?? '';
    if (id.isNotEmpty && mounted) {
      final idx = list.indexWhere((u) => u.id == id);
      if (idx >= 0) {
        setState(() {
          _state.usuarioActivo = list[idx];
          _state.puntos = list[idx].puntos;
          _state.aciertos = list[idx].aciertos;
          _state.racha = list[idx].racha;
        });
      }
    }
  }

  Future<void> _guardarEstado() async {
    if (_state.usuarioActivo == null) return;
    _state.usuarioActivo!.puntos = _state.puntos;
    _state.usuarioActivo!.aciertos = _state.aciertos;
    _state.usuarioActivo!.racha = _state.racha;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('usuarios') ?? '[]';
    final list = (json.decode(raw) as List).toList();
    final idx = list.indexWhere((e) =>
      (e as Map)['id'] == _state.usuarioActivo!.id);
    final jsonMap = _state.usuarioActivo!.toJson();
    if (idx >= 0) {
      list[idx] = jsonMap;
    } else {
      list.add(jsonMap);
    }
    await prefs.setString('usuarios', json.encode(list));
    await prefs.setString('usuarioActivoId', _state.usuarioActivo!.id);
  }

  Future<bool> _checkUser() async {
    if (_state.usuarioActivo == null) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Jugador requerido'),
          content: const Text('Primero registrá o seleccioná un jugador para poder jugar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Ir a Usuarios'),
            ),
          ],
        ),
      );
      if (confirm == true && mounted) await _onUsuarios();
      return false;
    }
    return true;
  }

  Future<void> _onUsuarios() async {
    await _guardarEstado();
    final result = await Navigator.push<Usuario>(
      context,
      MaterialPageRoute(builder: (_) => const UsuariosScreen()),
    );
    if (result != null && mounted) {
      setState(() {
        _state.usuarioActivo = result;
        _state.puntos = result.puntos;
        _state.aciertos = result.aciertos;
        _state.racha = result.racha;
      });
      await _guardarEstado();
    }
  }

  Future<void> _mostrarYaCompleto(String titulo) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$titulo ya completado'),
        content: const Text('Solo se puede jugar una vez.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateTrivia({bool demo = false}) async {
    if (!demo) {
      if (!await _checkUser()) return;
      if (!mounted) return;
      if (_state.usuarioActivo!.triviaCompletada) { _mostrarYaCompleto('Trivia'); return; }
    }
    if (!mounted) return;
    final result = await Navigator.push<TriviaResult>(
      context,
      MaterialPageRoute(builder: (_) => TriviaScreen(demo: demo)),
    );
    if (result != null && mounted && !demo) {
      setState(() {
        _state.puntos += result.puntos;
        _state.aciertos += result.correctas;
        if (result.rachaMax > _state.racha) _state.racha = result.rachaMax;
      });
      await _guardarEstado();
    }
  }

  Future<void> _navigateReaccion() async {
    if (!await _checkUser()) return;
    if (!mounted) return;
    if (_state.usuarioActivo!.reaccionCompletado) { _mostrarYaCompleto('Reacción'); return; }
    if (!mounted) return;
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => const ReaccionScreen()),
    );
    if (result != null && result > 0 && mounted) {
      _state.usuarioActivo!.reaccionPromedio = result;
      await _guardarEstado();
    }
  }

  Future<void> _navigateColorTest() async {
    if (!await _checkUser()) return;
    if (!mounted) return;
    if (_state.usuarioActivo!.colorTestCompletado) { _mostrarYaCompleto('Colores'); return; }
    if (!mounted) return;
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => const ColorTestScreen()),
    );
    if (result != null && result > 0 && mounted) {
      setState(() => _state.usuarioActivo!.colorTestPuntos += result);
      await _guardarEstado();
    }
  }

  Future<void> _navigateSonidoTest() async {
    if (!await _checkUser()) return;
    if (!mounted) return;
    if (_state.usuarioActivo!.sonidoTestCompletado) { _mostrarYaCompleto('Sonidos'); return; }
    if (!mounted) return;
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => const SonidoTestScreen()),
    );
    if (result != null && result > 0 && mounted) {
      setState(() => _state.usuarioActivo!.sonidoTestPuntos += result);
      await _guardarEstado();
    }
  }

  Future<void> _navigatePaisesTest() async {
    if (!await _checkUser()) return;
    if (!mounted) return;
    if (_state.usuarioActivo!.paisTestCompletado) { _mostrarYaCompleto('Países'); return; }
    if (!mounted) return;
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => const PaisesTestScreen()),
    );
    if (result != null && result > 0 && mounted) {
      setState(() => _state.usuarioActivo!.paisTestPuntos += result);
      await _guardarEstado();
    }
  }

  Future<void> _navigateTo(Widget screen) async {
    if (!await _checkUser()) return;
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeBody(
        state: _state,
        onUsuarios: _onUsuarios,
        onNavigateModelo: () => _navigateTo(const ModeloScreen()),
        onNavigateSituaciones: () => _navigateTo(const SituacionesScreen()),
        onNavigateTrivia: () => _navigateTrivia(),
        onNavigateDemo: () => _navigateTrivia(demo: true),
        onNavigateReaccion: () => _navigateReaccion(),
        onNavigateColorTest: () => _navigateColorTest(),
        onNavigateSonidoTest: () => _navigateSonidoTest(),
        onNavigatePaisesTest: () => _navigatePaisesTest(),
        onNavigateCircuito: () => _navigateTo(const CircuitoScreen()),
        onNavigateDiploma: () => _navigateTo(const DiplomaScreen()),
        onNavigateRanking: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const RankingScreen())),
        onNavigateAdmin: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AdminScreen())),
      ),
      bottomNavigationBar: _BottomNav(
        currentNav: _currentNav,
        onNav: (i) {
          setState(() => _currentNav = i);
          HapticFeedback.lightImpact();
          switch (i) {
            case 1: _navigateColorTest();
            case 2: _navigateSonidoTest();
            case 3: _navigateTrivia();
            case 4: _navigateReaccion();
            case 5: _navigateTrivia(demo: true);
            case 6: Navigator.push(context,
              MaterialPageRoute(builder: (_) => const RankingScreen()));
            case 7: Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AdminScreen()));
          }
        },
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentNav;
  final ValueChanged<int> onNav;
  const _BottomNav({required this.currentNav, required this.onNav});

  @override
  Widget build(BuildContext context) {
    final items = [
      _BNavItem(Icons.home_rounded, 'Inicio'),
      _BNavItem(Icons.palette_rounded, 'Colores'),
      _BNavItem(Icons.music_note_rounded, 'Sonidos'),
      _BNavItem(Icons.emoji_events_rounded, 'Trivia'),
      _BNavItem(Icons.timer_rounded, 'Reacción'),
      _BNavItem(Icons.school_rounded, 'Demo'),
      _BNavItem(Icons.leaderboard_rounded, 'Ranking'),
      _BNavItem(Icons.settings_rounded, 'Admin'),
    ];
    final size = MediaQuery.of(context).size;
    const itemWidth = 56.0;
    final needsScroll = items.length * itemWidth > size.width;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: needsScroll
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: items.asMap().entries.map((e) =>
                      _buildItem(e.key, e.value, itemWidth)
                    ).toList(),
                  ),
                )
              : Row(
                  children: items.asMap().entries.map((e) =>
                    Expanded(child: _buildItem(e.key, e.value, null))
                  ).toList(),
                ),
        ),
      ),
    );
  }

  Widget _buildItem(int index, _BNavItem item, double? width) {
    final active = currentNav == index;
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () => onNav(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 22,
                color: active ? AppTheme.primary : AppTheme.deactivatedText),
              const SizedBox(height: 2),
              Text(item.label, style: TextStyle(
                fontSize: 9, fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? AppTheme.primary : AppTheme.deactivatedText,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _BNavItem {
  final IconData icon;
  final String label;
  const _BNavItem(this.icon, this.label);
}

class _HomeBody extends StatelessWidget {
  final AppState state;
  final VoidCallback onUsuarios;
  final VoidCallback onNavigateModelo, onNavigateSituaciones;
  final VoidCallback onNavigateTrivia, onNavigateDemo;
  final VoidCallback onNavigateReaccion, onNavigateColorTest, onNavigateSonidoTest;
  final VoidCallback onNavigatePaisesTest;
  final VoidCallback onNavigateCircuito, onNavigateDiploma, onNavigateRanking;
  final VoidCallback onNavigateAdmin;

  const _HomeBody({
    required this.state, required this.onUsuarios,
    required this.onNavigateModelo, required this.onNavigateSituaciones,
    required this.onNavigateTrivia, required this.onNavigateDemo,
    required this.onNavigateReaccion, required this.onNavigateColorTest,
    required this.onNavigateSonidoTest, required this.onNavigatePaisesTest,
    required this.onNavigateCircuito,
    required this.onNavigateDiploma, required this.onNavigateRanking,
    required this.onNavigateAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _GItem(Icons.psychology_rounded, 'Modelo\nE-R-P-R-E', onNavigateModelo),
      _GItem(Icons.style_rounded, '20\nSituaciones', onNavigateSituaciones),
      _GItem(Icons.emoji_events_rounded, 'Trivia\nMundialera', onNavigateTrivia),
      _GItem(Icons.timer_rounded, 'Test de\nReacción', onNavigateReaccion),
      _GItem(Icons.palette_rounded, 'Test de\nColores', onNavigateColorTest),
      _GItem(Icons.music_note_rounded, 'Test de\nSonidos', onNavigateSonidoTest),
      _GItem(Icons.flag_rounded, 'Test de\nPaíses', onNavigatePaisesTest),
      _GItem(Icons.sensors_rounded, 'Circuito\nSensorial', onNavigateCircuito),
      _GItem(Icons.school_rounded, 'Diploma', onNavigateDiploma),
      _GItem(Icons.leaderboard_rounded, 'Ranking', onNavigateRanking),
      _GItem(Icons.people_rounded, 'Usuarios', onUsuarios),
      _GItem(Icons.settings_rounded, 'Admin', onNavigateAdmin),
    ];

    return SafeArea(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 12, mainAxisSpacing: 12,
              ),
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 400 + index * 60),
                  curve: Curves.fastOutSlowIn,
                  builder: (ctx, v, child) => Opacity(
                    opacity: v,
                    child: Transform.translate(
                      offset: Offset(0, 40 * (1 - v)),
                      child: child,
                    ),
                  ),
                  child: _buildGridTile(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16, right: 16, bottom: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('assets/images/logo.png',
                  width: 40, height: 40, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BioGol', style: AppTheme.headline.copyWith(
                      color: Colors.white, fontSize: 22)),
                    Text('Viví el Mundial con tu Sistema Nervioso',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              if (state.usuarioActivo != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${state.usuarioActivo!.puntosTotales} pts',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          if (state.usuarioActivo != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(state.usuarioActivo!.nombre,
                      style: const TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  if (state.usuarioActivo!.reaccionPromedio > 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text('Reacción: ${state.usuarioActivo!.reaccionPromedio}ms',
                        style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGridTile(_GItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: item.onTap,
        child: Container(
          decoration: AppTheme.card,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icono, size: 32, color: AppTheme.primary),
              const SizedBox(height: 8),
              Text(item.titulo, textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 13,
                  color: AppTheme.darkText,
                )),
            ],
          ),
        ),
      ),
    );
  }
}

class _GItem {
  final IconData icono;
  final String titulo;
  final VoidCallback onTap;
  _GItem(this.icono, this.titulo, this.onTap);
}
