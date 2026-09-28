import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hospital/core/theme/app_theme.dart';
import '../../../medications/presentation/providers/medication_provider.dart';
import '../../domain/entities/reminder.dart';
import '../providers/reminder_provider.dart';

class ReminderFormScreen extends StatefulWidget {
  final String userId;
  final Reminder? reminder;

  const ReminderFormScreen({super.key, required this.userId, this.reminder});

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  String? _selectedMedicationId;

  @override
  void initState() {
    super.initState();
    final reminder = widget.reminder;

    _nameController.text = reminder?.reminderName ?? '';
    _selectedDateTime = reminder?.startHour ?? DateTime.now();
    _selectedMedicationId = reminder?.medicationId.isNotEmpty == true
        ? reminder!.medicationId
        : null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MedicationProvider>().getMedications(widget.userId);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ReminderProvider>();
    final isEditing = widget.reminder != null;

    final reminderToSave = Reminder(
      uid: widget.reminder?.uid ?? '',
      reminderName: _nameController.text.trim(),
      userId: widget.userId.trim(),
      medicationId: _selectedMedicationId ?? '',
      startHour: _selectedDateTime,
      taken: widget.reminder?.taken ?? false,
    );

    bool success;
    if (isEditing) {
      success = await provider.update(reminderToSave, widget.userId);
    } else {
      success = await provider.save(reminderToSave, widget.userId);
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.reminder != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.light.colorScheme.primary,
        title: Text(
          isEditing ? 'Editar Recordatorio' : 'Nuevo Recordatorio',
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Digite el nombre del recordatorio',
                    labelText: 'Nombre del Recordatorio',
                    prefixIcon: Icon(Icons.text_format_sharp),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Ingresa un nombre' : null,
                ),
                const SizedBox(height: 16),

                // Selector de Medicamento
                Consumer<MedicationProvider>(
                  builder: (context, medProvider, child) {
                    if (medProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return DropdownButtonFormField<String>(
                      // Asegurarse de que el valor exista en la lista cargada, si no, usar null
                      initialValue:
                          medProvider.medication.any(
                            (m) => m.uid == _selectedMedicationId,
                          )
                          ? _selectedMedicationId
                          : null,
                      hint: const Text('Seleccione un medicamento'),
                      decoration: const InputDecoration(
                        labelText: 'Medicamento Asociado',
                        border: OutlineInputBorder(),
                      ),
                      items: medProvider.medication.map((med) {
                        return DropdownMenuItem<String>(
                          value: med.uid,
                          child: Text(med.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedMedicationId = val;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                ListTile(
                  tileColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  title: const Text('Hora del recordatorio'),
                  subtitle: Text(
                    '${_selectedDateTime.day}/${_selectedDateTime.month}/${_selectedDateTime.year} - ${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: _pickDateTime,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(isEditing ? 'Actualizar' : 'Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
