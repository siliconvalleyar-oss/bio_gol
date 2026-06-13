import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biogol/app_theme.dart';
import 'package:biogol/model/data.dart' as data;
import 'package:shared_preferences/shared_preferences.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});
  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final _nombreCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _aliasCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _customPaisCtrl = TextEditingController();
  String _paisSeleccionado = '';
  bool _esCustom = false;
  List<int> _customColores = [0xFF1565C0, 0xFFFFFFFF, 0xFFC62828];
  List<data.Usuario> _usuarios = [];

  static const List<Map<String, String>> paises = [
    {'flag': '🇦🇷', 'nom': 'Argentina'},
    {'flag': '🇧🇷', 'nom': 'Brasil'},
    {'flag': '🇺🇾', 'nom': 'Uruguay'},
    {'flag': '🇵🇾', 'nom': 'Paraguay'},
    {'flag': '🇨🇱', 'nom': 'Chile'},
    {'flag': '🇧🇴', 'nom': 'Bolivia'},
    {'flag': '🇵🇪', 'nom': 'Perú'},
    {'flag': '🇪🇨', 'nom': 'Ecuador'},
    {'flag': '🇨🇴', 'nom': 'Colombia'},
    {'flag': '🇻🇪', 'nom': 'Venezuela'},
    {'flag': '🇬🇾', 'nom': 'Guyana'},
    {'flag': '🇸🇷', 'nom': 'Surinam'},
    {'flag': '🇵🇦', 'nom': 'Panamá'},
    {'flag': '🇨🇷', 'nom': 'Costa Rica'},
    {'flag': '🇳🇮', 'nom': 'Nicaragua'},
    {'flag': '🇭🇳', 'nom': 'Honduras'},
    {'flag': '🇸🇻', 'nom': 'El Salvador'},
    {'flag': '🇬🇹', 'nom': 'Guatemala'},
    {'flag': '🇲🇽', 'nom': 'México'},
    {'flag': '🇨🇺', 'nom': 'Cuba'},
    {'flag': '🇩🇴', 'nom': 'República Dominicana'},
    {'flag': '🇭🇹', 'nom': 'Haití'},
    {'flag': '🇨🇦', 'nom': 'Canadá'},
    {'flag': '🇺🇸', 'nom': 'Estados Unidos'},
    {'flag': '🇫🇷', 'nom': 'Francia'},
    {'flag': '🇩🇪', 'nom': 'Alemania'},
    {'flag': '🇮🇹', 'nom': 'Italia'},
    {'flag': '🏴󠁧󠁢󠁥󠁮󠁧󠁿', 'nom': 'Inglaterra'},
    {'flag': '🇵🇹', 'nom': 'Portugal'},
    {'flag': '🇳🇱', 'nom': 'Países Bajos'},
    {'flag': '🇪🇸', 'nom': 'España'},
    {'flag': '🇧🇪', 'nom': 'Bélgica'},
    {'flag': '🇭🇷', 'nom': 'Croacia'},
    {'flag': '🇷🇸', 'nom': 'Serbia'},
    {'flag': '🇨🇭', 'nom': 'Suiza'},
    {'flag': '🇸🇪', 'nom': 'Suecia'},
    {'flag': '🇩🇰', 'nom': 'Dinamarca'},
    {'flag': '🇳🇴', 'nom': 'Noruega'},
    {'flag': '🇵🇱', 'nom': 'Polonia'},
    {'flag': '🇺🇦', 'nom': 'Ucrania'},
    {'flag': '🇷🇺', 'nom': 'Rusia'},
    {'flag': '🇨🇳', 'nom': 'China'},
    {'flag': '🇯🇵', 'nom': 'Japón'},
    {'flag': '🇰🇷', 'nom': 'Corea del Sur'},
    {'flag': '🇮🇷', 'nom': 'Irán'},
    {'flag': '🇸🇦', 'nom': 'Arabia Saudita'},
    {'flag': '🇦🇺', 'nom': 'Australia'},
    {'flag': '🇰🇪', 'nom': 'Kenia'},
    {'flag': '🇳🇬', 'nom': 'Nigeria'},
    {'flag': '🇸🇳', 'nom': 'Senegal'},
    {'flag': '🇲🇦', 'nom': 'Marruecos'},
    {'flag': '🇩🇿', 'nom': 'Argelia'},
    {'flag': '🇪🇬', 'nom': 'Egipto'},
    {'flag': '🇿🇦', 'nom': 'Sudáfrica'},
    {'flag': '🇬🇭', 'nom': 'Ghana'},
    {'flag': '🇨🇲', 'nom': 'Camerún'},
    {'flag': '🇨🇮', 'nom': 'Costa de Marfil'},
    {'flag': '🇹🇳', 'nom': 'Túnez'},
    {'flag': '🏴󠁧󠁢󠁷󠁬󠁳󠁿', 'nom': 'Gales'},
    {'flag': '🏴󠁧󠁢󠁳󠁣󠁴󠁿', 'nom': 'Escocia'},
    {'flag': '🇮🇪', 'nom': 'Irlanda'},
    {'flag': '🇹🇷', 'nom': 'Turquía'},
    {'flag': '🇦🇹', 'nom': 'Austria'},
    {'flag': '🇭🇺', 'nom': 'Hungría'},
    {'flag': '🇷🇴', 'nom': 'Rumania'},
    {'flag': '🇧🇬', 'nom': 'Bulgaria'},
    {'flag': '🇬🇷', 'nom': 'Grecia'},
    {'flag': '🇮🇳', 'nom': 'India'},
    {'flag': '🇸🇬', 'nom': 'Singapur'},
    {'flag': '🇲🇾', 'nom': 'Malasia'},
    {'flag': '🇮🇩', 'nom': 'Indonesia'},
    {'flag': '🇵🇭', 'nom': 'Filipinas'},
    {'flag': '🇳🇿', 'nom': 'Nueva Zelanda'},
    {'flag': '🎨', 'nom': 'Personalizado'},
  ];

  static const List<Color> _colorOptions = [
    Color(0xFF1565C0), Color(0xFFFFFFFF), Color(0xFFC62828),
    Color(0xFF2E7D32), Color(0xFFFDD835), Color(0xFFE65100),
    Color(0xFF6A1B9A), Color(0xFF000000), Color(0xFF4DD0E1),
    Color(0xFFFF8A65), Color(0xFF795548), Color(0xFF9E9E9E),
  ];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _edadCtrl.dispose();
    _aliasCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
    _customPaisCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('usuarios') ?? '[]';
    final list = (json.decode(raw) as List).map((e) =>
      data.Usuario.fromJson(e as Map<String, dynamic>)).toList();
    setState(() => _usuarios = list);
  }

  void _onPaisChanged(String? value) {
    if (value == null) return;
    setState(() {
      _paisSeleccionado = value;
      _esCustom = value == 'CUSTOM';
      if (_esCustom && _customColores.isEmpty) {
        _customColores = [0xFF1565C0, 0xFFFFFFFF, 0xFFC62828];
      }
    });
  }

  String _customPaisValue() {
    final name = _customPaisCtrl.text.trim();
    if (name.isEmpty) return '';
    final colores = _customColores.map((c) =>
      '#${c.toRadixString(16).padLeft(8, '0')}').join(':');
    return 'CUSTOM:$name:$colores';
  }

  Future<void> _guardar() async {
    final nom = _nombreCtrl.text.trim();
    if (nom.isEmpty) { _showMsg('Ingresá un nombre.'); return; }
    String pais = _paisSeleccionado;
    if (_esCustom) {
      pais = _customPaisValue();
      if (pais.isEmpty) { _showMsg('Ingresá un nombre para tu bandera.'); return; }
    } else if (pais.isEmpty) {
      _showMsg('Seleccioná un país.'); return;
    }
    final u = data.Usuario(
      nombre: nom, edad: _edadCtrl.text.trim(),
      alias: _aliasCtrl.text.trim(), pais: pais,
      email: _emailCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim(),
    );
    _usuarios.add(u);
    await _persistir();
    _nombreCtrl.clear(); _edadCtrl.clear(); _aliasCtrl.clear();
    _emailCtrl.clear(); _telefonoCtrl.clear();
    _customPaisCtrl.clear();
    _paisSeleccionado = '';
    _esCustom = false;
    _customColores = [0xFF1565C0, 0xFFFFFFFF, 0xFFC62828];
    _showMsg('Usuario guardado');
  }

  Future<void> _persistir() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = json.encode(_usuarios.map((u) => u.toJson()).toList());
    await prefs.setString('usuarios', raw);
    setState(() {});
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<void> _exportarCSV() async {
    if (_usuarios.isEmpty) { _showMsg('No hay usuarios guardados.'); return; }
    final buf = StringBuffer('Nombre,Edad,Alias,Pais,Puntos,Aciertos,Racha,Fecha\n');
    for (final u in _usuarios) {
      buf.writeln('"${u.nombre}","${u.edad}","${u.alias}","${u.paisDisplay}",${u.puntos},${u.aciertos},${u.racha},"${u.fecha}"');
    }
    await Clipboard.setData(ClipboardData(text: buf.toString()));
    _showMsg('CSV copiado al portapapeles');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      appBar: AppBar(title: const Text('Usuarios')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildForm(),
            const SizedBox(height: 16),
            _buildTable(),
          ],
        ),
      ),
    );
  }

  Widget _colorPicker(int currentColor, ValueChanged<Color> onPick) {
    return PopupMenuButton<Color>(
      onSelected: onPick,
      offset: const Offset(0, 40),
      itemBuilder: (_) => _colorOptions.map((c) => PopupMenuItem(
        value: c,
        child: Row(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(width: 8),
            Text('#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
              style: const TextStyle(fontSize: 12)),
          ],
        ),
      )).toList(),
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: Color(currentColor),
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.border, width: 2),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Registrar Usuario', style: AppTheme.title),
          const SizedBox(height: 12),
          TextField(controller: _nombreCtrl, decoration: const InputDecoration(
            labelText: 'Nombre', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: _edadCtrl, keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Edad (0-120)', border: OutlineInputBorder()),
            onChanged: (v) {
              final n = int.tryParse(v);
              if (n != null && (n < 0 || n > 120)) {
                _edadCtrl.text = n.clamp(0, 120).toString();
                _edadCtrl.selection = TextSelection.fromPosition(
                  TextPosition(offset: _edadCtrl.text.length));
              }
            },
          ),
          const SizedBox(height: 8),
          TextField(controller: _aliasCtrl, decoration: const InputDecoration(
            labelText: 'Alias (@usuario)', border: OutlineInputBorder()),
            onChanged: (v) {
              if (!v.startsWith('@')) {
                _aliasCtrl.text = '@$v';
                _aliasCtrl.selection = TextSelection.fromPosition(
                  TextPosition(offset: _aliasCtrl.text.length));
              }
            },
          ),
          const SizedBox(height: 8),
          TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: _telefonoCtrl, keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Teléfono (con código país, ej: +541112345678)',
              border: OutlineInputBorder())),
          const SizedBox(height: 8),
          const Text('País / Bandera:', style: AppTheme.subtitle),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _paisSeleccionado.isEmpty ? null : _paisSeleccionado,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              isDense: true,
            ),
            hint: const Text('Seleccioná un país', style: TextStyle(fontSize: 14)),
            isExpanded: true,
            items: paises.map((p) => DropdownMenuItem(
              value: p['flag'],
              child: Text('${p['flag']} ${p['nom']}', style: const TextStyle(fontSize: 14)),
            )).toList(),
            onChanged: _onPaisChanged,
          ),
          if (_esCustom) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _customPaisCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre de tu bandera',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Franjas:', style: AppTheme.subtitle),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                  onPressed: _customColores.length > 1
                      ? () => setState(() => _customColores.removeLast())
                      : null,
                ),
                Text('${_customColores.length}',
                  style: AppTheme.body1),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  onPressed: _customColores.length < 4
                      ? () => setState(() => _customColores.add(0xFFFFFFFF))
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 6),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _customColores.length,
              onReorderItem: (oldI, newI) => setState(() {
                final c = _customColores.removeAt(oldI);
                _customColores.insert(newI, c);
              }),
              itemBuilder: (_, i) => Padding(
                key: ValueKey('color_$i'),
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    _colorPicker(_customColores[i], (c) =>
                      setState(() => _customColores[i] = c.toARGB32())),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                          color: Color(_customColores[i]),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppTheme.border),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.drag_handle, size: 18,
                      color: AppTheme.deactivatedText),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 28,
                child: Row(
                  children: _customColores.map((c) =>
                    Expanded(child: Container(color: Color(c)))
                  ).toList(),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _guardar,
              style: AppTheme.minimalButton,
              child: const Text('Guardar Usuario'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Usuarios Guardados', style: AppTheme.title),
          const SizedBox(height: 12),
          if (_usuarios.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Sin usuarios registrados.',
                style: TextStyle(color: AppTheme.deactivatedText)),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 10,
                headingRowColor: WidgetStateProperty.all(AppTheme.grayLight),
                columns: const [
                  DataColumn(label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.w600))),
                  DataColumn(label: Text('Alias', style: TextStyle(fontWeight: FontWeight.w600))),
                  DataColumn(label: Text('País', style: TextStyle(fontWeight: FontWeight.w600))),
                  DataColumn(label: Text('Edad', style: TextStyle(fontWeight: FontWeight.w600))),
                  DataColumn(label: Text('Pts', style: TextStyle(fontWeight: FontWeight.w600))),
                  DataColumn(label: Text('')),
                ],
                rows: _usuarios.asMap().entries.map((e) {
                  final u = e.value;
                  return DataRow(cells: [
                    DataCell(Text(u.nombre)),
                    DataCell(Text(u.alias.isEmpty ? '-' : u.alias)),
                    DataCell(u.esCustomPais
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 24, height: 16,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Row(
                                    children: (u.customPaisColores ?? []).map((c) =>
                                      Expanded(child: Container(color: c))
                                    ).toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(u.paisDisplay),
                            ],
                          )
                        : Text(u.pais.isEmpty ? '-' : u.pais)),
                    DataCell(Text(u.edad.isEmpty ? '-' : u.edad)),
                    DataCell(Text('${u.puntosTotales}')),
                    DataCell(
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, _usuarios[e.key]);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          side: const BorderSide(color: AppTheme.primary),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Jugar', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _exportarCSV,
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Exportar CSV'),
              style: AppTheme.minimalButton,
            ),
          ),
        ],
      ),
    );
  }
}
