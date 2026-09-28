import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hospital/core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/form_field_widget.dart';
import '../../../../core/presentation/widgets/button_widget.dart';
import '../../domain/entities/user_role.dart';
import '../provider/auth_provider.dart';
import '../../../../core/validators/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _registrarUsuario(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await auth.register(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      role: auth.selectedRole?.dbValue ?? 'paciente',
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '¡Usuario registrado con éxito! Por favor disfruta de la aplicación.',
          ),
        ),
      );
    } else if (auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.light.colorScheme.primary,
        title: Text(
          'Registro de Usuario',
          style: TextStyle(
            fontSize: AppFontSize.title,
            color: AppTheme.light.colorScheme.onPrimary,
          ),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Registrar Nuevo Usuario',
                style: TextStyle(
                  fontSize: AppFontSize.headline,
                  color: AppTheme.light.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: FormFieldWidget(
                  controller: _emailController,
                  validator: (v) => Validators.email(v),
                  text: 'Email',
                  hintText: 'Ingrese su correo electrónico',
                  type: TextInputType.emailAddress,
                  icon: Icons.email,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: FormFieldWidget(
                  controller: _passwordController,
                  validator: (v) => Validators.password(v),
                  text: 'Contraseña',
                  hintText: 'Ingrese su contraseña',
                  type: TextInputType.text,
                  icon: Icons.lock,
                  obscureText: true,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: FormFieldWidget(
                  controller: _usernameController,
                  validator: (v) => Validators.requiredField(
                    v,
                    customMessage: 'El nombre de usuario es requerido',
                  ),
                  text: 'Nombre de Usuario',
                  hintText: 'Ingrese su nombre de usuario',
                  type: TextInputType.text,
                  icon: Icons.person,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<UserRole>(
                  hint: Text('Seleccione un rol'),
                  decoration: const InputDecoration(
                    labelText: 'Rol de Usuario',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  // Mapeamos las opciones del enum directamente
                  items: UserRole.values.map((UserRole role) {
                    return DropdownMenuItem<UserRole>(
                      value: role,
                      child: Text(role.label), // Muestra "Paciente" o "Médico"
                    );
                  }).toList(),
                  onChanged: (UserRole? newRole) {
                    if (newRole != null) {
                      // Actualizamos el Provider al seleccionar
                      context.read<AuthProvider>().setRole(newRole);
                    }
                  },
                  validator: (role) => Validators.requiredRole(role),
                ),
              ),
              SizedBox(height: 24),
              authProvider.isLoading
                  ? CircularProgressIndicator()
                  : ButtonWidget(
                      onPressed: () => _registrarUsuario(authProvider),
                      text: 'Registrarse',
                      icon: Icons.person_add,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
