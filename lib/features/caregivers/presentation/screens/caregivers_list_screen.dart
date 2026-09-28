import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hospital/core/theme/app_theme.dart';
import '../../domain/entities/caregivers.dart';
import '../providers/caregivers_provider.dart';
import 'caregivers_form_screen.dart';

class CaregiversListScreen extends StatefulWidget {
  final String userId;

  const CaregiversListScreen({super.key, required this.userId});

  @override
  State<CaregiversListScreen> createState() => _CaregiversListScreenState();
}

class _CaregiversListScreenState extends State<CaregiversListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CaregiversProvider>().getCaregivers(widget.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cuidadores', style: AppTheme.light.textTheme.headlineLarge),
            ],
          ),
        ),
        Expanded(
          child: Consumer<CaregiversProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.caregivers.isEmpty) {
                return const Center(
                  child: Text('No tienes cuidadores registrados.'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: provider.caregivers.length,
                itemBuilder: (context, index) {
                  final caregiver = provider.caregivers[index];
                  return _CaregiverCard(
                    caregiver: caregiver,
                    userId: widget.userId,
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

class _CaregiverCard extends StatelessWidget {
  final Caregiver caregiver;
  final String userId;

  const _CaregiverCard({required this.caregiver, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.light.primaryColor,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(caregiver.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(caregiver.email),
            Text(caregiver.phone),
            Text('Relación: ${caregiver.relationship}'),
            if (caregiver.isPrimary) const Text('Principal'),
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
                    builder: (_) => CaregiversFormScreen(
                      userId: userId,
                      initialCaregiver: caregiver,
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
                    title: const Text('Eliminar cuidador'),
                    content: const Text(
                      '¿Deseas eliminar este cuidador del registro?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await context.read<CaregiversProvider>().deleteCaregiver(
                    caregiver.uid,
                    userId,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
