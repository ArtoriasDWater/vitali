import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hospital/core/theme/app_theme.dart';
import '../../domain/entities/caregivers.dart';
import '../providers/caregivers_provider.dart';

class CaregiversFormScreen extends StatefulWidget {
  final String userId;
  final Caregiver? initialCaregiver;

  const CaregiversFormScreen({
    super.key,
    required this.userId,
    this.initialCaregiver,
  });

  @override
  State<CaregiversFormScreen> createState() => _CaregiversFormScreenState();
}

class _CaregiversFormScreenState extends State<CaregiversFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _relationshipController;

  bool get _isEditing =>
      widget.initialCaregiver != null &&
      widget.initialCaregiver!.uid.isNotEmpty;

  bool _isPrimary = false;
  bool _active = true;

  @override
  void initState() {
    super.initState();
    final caregiver = widget.initialCaregiver;
    _nameController = TextEditingController(text: caregiver?.name ?? '');
    _emailController = TextEditingController(text: caregiver?.email ?? '');
    _phoneController = TextEditingController(text: caregiver?.phone ?? '');
    _relationshipController = TextEditingController(
      text: caregiver?.relationship ?? '',
    );
    _isPrimary = caregiver?.isPrimary ?? false;
    _active = caregiver?.active ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CaregiversProvider>();

    final caregiver = Caregiver(
      uid: _isEditing ? widget.initialCaregiver!.uid : '',
      userId: widget.userId,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      relationship: _relationshipController.text.trim(),
      isPrimary: _isPrimary,
      active: _active,
      createdAt: widget.initialCaregiver?.createdAt ?? DateTime.now(),
    );

    bool success;
    if (_isEditing) {
      success = await provider.updateCaregiver(caregiver);
    } else {
      success = await provider.saveCaregiver(caregiver);
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Cuidador actualizado correctamente.'
                : 'Cuidador guardado correctamente.',
          ),
        ),
      );
      Navigator.pop(context);
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.light.primaryColor,
        title: Text(
          _isEditing ? 'Editar cuidador' : 'Nuevo cuidador',
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
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Ingresa el nombre'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Ingresa el correo'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Ingresa el teléfono'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _relationshipController,
                decoration: const InputDecoration(
                  labelText: 'Relación con el paciente',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Ingresa la relación'
                    : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Es principal'),
                value: _isPrimary,
                onChanged: (value) => setState(() => _isPrimary = value),
              ),
              SwitchListTile(
                title: const Text('Activo'),
                value: _active,
                onChanged: (value) => setState(() => _active = value),
              ),
              const SizedBox(height: 24),
              Consumer<CaregiversProvider>(
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
