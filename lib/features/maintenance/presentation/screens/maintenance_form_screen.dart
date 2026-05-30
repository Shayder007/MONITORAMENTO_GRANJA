import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../features/barns/domain/barn_structure.dart';
import '../../domain/maintenance_record.dart';
import '../providers/maintenance_providers.dart';

class MaintenanceFormScreen extends ConsumerStatefulWidget {
  const MaintenanceFormScreen({
    super.key,
    required this.barn,
    required this.motor,
  });

  final BarnUnit barn;
  final BarnMotor motor;

  @override
  ConsumerState<MaintenanceFormScreen> createState() =>
      _MaintenanceFormScreenState();
}

class _MaintenanceFormScreenState
    extends ConsumerState<MaintenanceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _technicianController = TextEditingController();
  final _notesController = TextEditingController();

  MaintenanceType _selectedType = MaintenanceType.generalInspection;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _descriptionController.dispose();
    _technicianController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final record = MaintenanceRecord(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      barnId: widget.barn.id,
      barnName: widget.barn.name,
      motorId: widget.motor.id,
      motorLine: widget.motor.line,
      type: _selectedType,
      description: _descriptionController.text.trim(),
      technician: _technicianController.text.trim(),
      performedAt: _selectedDate,
      notes: _notesController.text.trim(),
    );

    ref.read(maintenanceProvider.notifier).add(record);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Manutenção registrada com sucesso!')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Manutenção'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info do galpão e linha (somente leitura)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Galpão / Linha',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        )),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.warehouse_rounded, size: 18),
                        const SizedBox(width: 6),
                        Text(widget.barn.name,
                            style: theme.textTheme.bodyLarge),
                        const SizedBox(width: 16),
                        const Icon(Icons.view_week_rounded, size: 18),
                        const SizedBox(width: 6),
                        Text(widget.motor.line,
                            style: theme.textTheme.bodyLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tipo de manutenção
            DropdownButtonFormField<MaintenanceType>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Tipo de manutenção',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.build_rounded),
              ),
              items: MaintenanceType.values
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.label),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedType = v);
              },
            ),
            const SizedBox(height: 16),

            // Descrição
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição do serviço',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description_rounded),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe a descrição' : null,
            ),
            const SizedBox(height: 16),

            // Técnico
            TextFormField(
              controller: _technicianController,
              decoration: const InputDecoration(
                labelText: 'Técnico responsável',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_rounded),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe o técnico' : null,
            ),
            const SizedBox(height: 16),

            // Data
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data de realização',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                ),
                child: Text(dateStr, style: theme.textTheme.bodyLarge),
              ),
            ),
            const SizedBox(height: 16),

            // Observações (opcional)
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Observações (opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes_rounded),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Salvar manutenção'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
