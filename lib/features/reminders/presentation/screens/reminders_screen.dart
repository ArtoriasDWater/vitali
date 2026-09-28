import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hospital/core/theme/app_theme.dart';
import '../providers/reminder_provider.dart';
import 'reminder_form_screen.dart';

class RemindersScreen extends StatefulWidget {
  final String userId;

  const RemindersScreen({super.key, required this.userId});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReminderProvider>().getReminders(widget.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Encabezado de la sección (Título sin botón de cámara)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recordatorios',
                style: AppTheme.light.textTheme.headlineLarge,
              ),
            ],
          ),
        ),

        // 2. Expanded como hijo directo de Column
        Expanded(
          child: Consumer<ReminderProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.errorMessage != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (provider.reminders.isEmpty) {
                return const Center(
                  child: Text('No tienes recordatorios registrados.'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: provider.reminders.length,
                itemBuilder: (context, index) {
                  final reminder = provider.reminders[index];
                  String timeFormatted = '--:--';
                  try {
                    timeFormatted =
                        '${reminder.startHour.hour.toString().padLeft(2, '0')}:${reminder.startHour.minute.toString().padLeft(2, '0')}';
                  } catch (e) {
                    timeFormatted = 'Hora no valida';
                  }

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Checkbox(
                        value: reminder.taken,
                        onChanged: (bool? value) {
                          if (value != null) {
                            provider.toggleTaken(
                              reminder.uid,
                              value,
                              widget.userId,
                            );
                          }
                        },
                      ),
                      title: Text(
                        reminder.reminderName,
                        style: TextStyle(
                          fontSize: AppFontSize.body,
                          color: AppTheme.light.primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: reminder.taken
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text('Hora: $timeFormatted')],
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
                                  builder: (_) => ReminderFormScreen(
                                    userId: widget.userId,
                                    reminder: reminder,
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
                                    '¿Deseas eliminar este recordatorio?',
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
                                await provider.delete(
                                  reminder.uid,
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
