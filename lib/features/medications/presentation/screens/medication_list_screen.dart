import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_hospital/core/theme/app_theme.dart';
import 'dart:io';
import '../providers/medication_provider.dart';
import '../screens/medication_form_screen.dart';

class MedicationListScreen extends StatefulWidget {
  final String userId;
  const MedicationListScreen({super.key, required this.userId});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MedicationProvider>().getMedications(widget.userId);
      }
    });
  }

  /// Procesa la captura de la receta mediante cámara o galería
  Future<void> _pickAndScanImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return;

    if (!mounted) return;
    final provider = context.read<MedicationProvider>();
    final success = await provider.scanRecipe(File(image.path), widget.userId);

    if (success && mounted) {
      // Abre el formulario con los datos pre-llenados del OCR
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MedicationFormScreen(userId: widget.userId),
        ),
      );
    } else if (mounted && provider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Encabezado de la sección (Título + Botón de Cámara)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Medicamentos',
                style: AppTheme.light.textTheme.headlineLarge,
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt),
                tooltip: 'Escanear receta',
                onPressed: () => _pickAndScanImage(ImageSource.camera),
              ),
            ],
          ),
        ),

        // 2. Expanded va como HIJO DIRECTO de la Column para tomar el alto restante
        Expanded(
          child: Consumer<MedicationProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.medication.isEmpty) {
                return const Center(
                  child: Text('No tienes medicamentos registrados.'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: provider.medication.length,
                itemBuilder: (context, index) {
                  final medication = provider.medication[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.medication),
                      ),
                      title: Text(
                        medication.name,
                        style: TextStyle(
                          fontSize: AppFontSize.body,
                          color: AppTheme.light.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${medication.numberOfPills} pastilla(s) | Frecuencia: ${medication.frequency}',
                          ),
                          if (medication.observations.isNotEmpty)
                            Text(
                              'Obs: ${medication.observations}',
                              style: TextStyle(color: AppTheme.light.hintColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MedicationFormScreen(
                                    userId: widget.userId,
                                    initialMedication: medication,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Eliminar'),
                                  content: const Text(
                                    '¿Deseas eliminar este medicamento?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true && mounted) {
                                await provider.deleteMedication(
                                  medication.uid,
                                  widget.userId,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
