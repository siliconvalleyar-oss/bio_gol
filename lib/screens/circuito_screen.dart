import 'package:flutter/material.dart';
import 'package:biogol/app_theme.dart';
import 'package:biogol/model/data.dart' as data;

class CircuitoScreen extends StatefulWidget {
  const CircuitoScreen({super.key});
  @override
  State<CircuitoScreen> createState() => _CircuitoScreenState();
}

class _CircuitoScreenState extends State<CircuitoScreen> {
  final List<bool> _done = [false, false, false, false, false];
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final allDone = _done.every((d) => d);
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      appBar: AppBar(title: const Text('Circuito Sensorial')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: AppTheme.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Circuito Sensorial', style: AppTheme.title),
                  const SizedBox(height: 4),
                  Text('Completá las 5 estaciones.',
                    style: AppTheme.body2.copyWith(color: AppTheme.lightText)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: data.EstacionSensorial.lista.length,
              itemBuilder: (context, i) {
                final e = data.EstacionSensorial.lista[i];
                final isDone = _done[i];
                final isSelected = _selected == i;
                return GestureDetector(
                  onTap: isDone ? null : () => setState(() => _selected = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDone ? AppTheme.successLight
                          : isSelected ? AppTheme.primaryLight
                          : AppTheme.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDone ? AppTheme.success
                            : isSelected ? AppTheme.primary
                            : AppTheme.border,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(e.icono, style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 6),
                        Text(e.nombre, style: AppTheme.title),
                        const SizedBox(height: 4),
                        Text(isDone ? 'Completado' : 'Pendiente',
                          style: AppTheme.caption.copyWith(
                            color: isDone ? AppTheme.success : AppTheme.deactivatedText)),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (_selected != null && !_done[_selected!]) ...[
              const SizedBox(height: 16),
              _buildDetailCard(_selected!),
            ],
            if (allDone) ...[
              const SizedBox(height: 16),
              _buildCompleteCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(int i) {
    final e = data.EstacionSensorial.lista[i];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card,
      child: Column(
        children: [
          Text(e.icono, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(e.nombre, style: AppTheme.title),
          const SizedBox(height: 8),
          Text(e.descripcion, textAlign: TextAlign.center, style: AppTheme.body1),
          const SizedBox(height: 6),
          Text('${e.estimulo}  ·  ${e.receptor}',
            style: AppTheme.body2.copyWith(color: AppTheme.lightText)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => setState(() {
                _done[i] = true;
                _selected = null;
              }),
              style: AppTheme.minimalPrimary,
              child: const Text('Completar estación'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.card.copyWith(
        color: AppTheme.successLight,
        border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Text('Circuito completado',
            style: AppTheme.title),
          const SizedBox(height: 6),
          Text('Respondiste a todos los estímulos.',
            textAlign: TextAlign.center, style: AppTheme.body1),
        ],
      ),
    );
  }
}
