import 'package:flutter/material.dart';
import 'package:biogol/app_theme.dart';
import 'package:biogol/model/data.dart' as data;

class SituacionesScreen extends StatefulWidget {
  const SituacionesScreen({super.key});
  @override
  State<SituacionesScreen> createState() => _SituacionesScreenState();
}

class _SituacionesScreenState extends State<SituacionesScreen> {
  final Set<int> _flipped = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      appBar: AppBar(title: const Text('20 Situaciones')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: data.Situacion.lista.length,
        itemBuilder: (context, index) {
          final s = data.Situacion.lista[index];
          final isFlipped = _flipped.contains(s.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isFlipped) { _flipped.remove(s.id); }
                  else { _flipped.add(s.id); }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isFlipped ? _buildBack(s) : _buildFront(s),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFront(data.Situacion s) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('#${s.id}', style: AppTheme.caption.copyWith(
            color: AppTheme.primary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(s.texto, style: AppTheme.body1),
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              Text('Tocá para ver respuesta',
                style: AppTheme.caption.copyWith(color: AppTheme.deactivatedText)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBack(data.Situacion s) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card.copyWith(
        color: AppTheme.successLight,
        border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('#${s.id} — Respuesta',
            style: AppTheme.title.copyWith(color: AppTheme.success)),
          const SizedBox(height: 8),
          _buildRow('E', s.estimulo),
          _buildRow('R', s.receptor),
          _buildRow('P', s.procesamiento),
          _buildRow('R', s.respuesta),
          _buildRow('Ef', s.efector),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 26,
            child: Text('$label:', style: AppTheme.body2.copyWith(
              fontWeight: FontWeight.w600, color: AppTheme.success)),
          ),
          Expanded(child: Text(value, style: AppTheme.body2)),
        ],
      ),
    );
  }
}
