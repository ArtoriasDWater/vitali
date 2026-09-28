//Importaciones de paquetes necesarios para la pantalla de inicio de sesión
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hospital/features/auth/presentation/screens/register_screen.dart';

//Importaciones de archivos locales
import '../../../../core/theme/app_theme.dart';
import '../../../../core/presentation/widgets/form_field_widget.dart';
import '../../../../core/presentation/widgets/button_widget.dart';
import '../widgets/google_button.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> _iniciarSesion(AuthProvider auth) async {
    final success = await auth.signInWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );

    if (!mounted) return false;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Inicio de sesión exitoso!')),
      );
    } else if (auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }

    return success;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(16),
                child: Image.asset(
                  'assets/images/image.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                'Bienvenido a Vitali',
                style: TextStyle(
                  fontSize: AppFontSize.headline,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: FormFieldWidget(
                  controller: emailController,
                  validator: (v) {
                    if (v == null) return 'debe digitar el email';

                    return '';
                  },
                  hintText: 'Digite su email',
                  text: 'Email',
                  icon: Icons.email,
                  type: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: FormFieldWidget(
                  controller: passwordController,
                  validator: (v) => '',
                  hintText: 'ingresa la contraseña',
                  text: 'Password',
                  icon: Icons.password,
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    authProvider.isLoading
                        ? CircularProgressIndicator()
                        : ButtonWidget(
                            text: 'Iniciar sesión',
                            onPressed: () => _iniciarSesion(authProvider),
                            icon: Icons.login,
                          ),
                    SizedBox(width: 10),
                    ButtonWidget(
                      text: 'Registrarse',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      icon: Icons.person_add,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GoogleButton(
                text: 'Iniciar sesión con Google',
                onPressed: () => authProvider.signInWithGoogle(),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Lógica para recuperar contraseña
                },
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    color: AppTheme.light.colorScheme.primary,
                    fontSize: AppFontSize.body,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
