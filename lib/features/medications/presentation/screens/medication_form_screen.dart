import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hospital/core/theme/app_theme.dart';
import '../../domain/entities/medication.dart';
import '../providers/medication_provider.dart';

class MedicationFormScreen extends StatefulWidget {
  final String userId;
  final Medication? initialMedication;

  const MedicationFormScreen({
    super.key,
    required this.userId,
    this.initialMedication,
  });

  @override
  State<MedicationFormScreen> createState() => _MedicationFormScreenState();
}

class _MedicationFormScreenState extends State<MedicationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _pillsController;
  late TextEditingController _frequencyController;
  late TextEditingController _observationsController;

  bool get _isEditing =>
      widget.initialMedication != null &&
      widget.initialMedication!.uid.isNotEmpty;

  @override
  void initState() {
    super.initState();
    final med = widget.initialMedication;
    _nameController = TextEditingController(text: med?.name ?? '');
    _pillsController = TextEditingController(
      text: med?.numberOfPills.toString() ?? '1',
    );
    _frequencyController = TextEditingController(text: med?.frequency ?? '');
    _observationsController = TextEditingController(
      text: med?.observations ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pillsController.dispose();
    _frequencyController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<MedicationProvider>();

    final medication = Medication(
      uid: _isEditing ? widget.initialMedication!.uid : '',
      name: _nameController.text.trim(),
      numberOfPills: int.tryParse(_pillsController.text.trim()) ?? 1,
      frequency: _frequencyController.text.trim(),
      observations: _observationsController.text.trim(),
      userId: widget.userId,
    );

    bool success;
    if (_isEditing) {
      success = await provider.updateMedication(medication);
    } else {
      success = await provider.saveMedication(medication);
    }

    if (mounted) {
      if (success) {
        if (_isEditing) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Se ha actualizado el medicamento con exito.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Se ha guardado el medicamento con exito.')),
          );
        }
        Navigator.pop(context);
      } else if (provider.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.light.primaryColor,
        title: Text(
          _isEditing ? 'Editar Medicamento' : 'Nuevo Medicamento',
          style: TextStyle(
            fontSize: AppFontSize.title,
            color: AppTheme.light.colorScheme.onPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Medicamento',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Ingresa el nombre' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pillsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de Pastillas/Dosis',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Ingresa la cantidad' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _frequencyController,
                decoration: const InputDecoration(
                  labelText: 'Frecuencia (ej. Cada 8 horas)',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Ingresa la frecuencia' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _observationsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observaciones / Notas',
                ),
              ),
              const SizedBox(height: 24),
              Consumer<MedicationProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton(
                    onPressed: provider.isLoading ? null : _submitForm,
                    child: provider.isLoading
                        ? const CircularProgressIndicator()
                        : Text(_isEditing ? 'Actualizar' : 'Guardar'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
