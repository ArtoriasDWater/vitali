//Campos de texto para el formulario de registro.
import 'package:flutter/material.dart';

class FormFieldWidget extends StatelessWidget {
  final String hintText;
  final String text;
  final IconData icon;
  final TextInputType type;
  final bool obscureText;

  final TextEditingController controller;
  final FormFieldValidator validator;

  const FormFieldWidget({
    super.key,
    required this.controller,
    required this.validator,
    required this.hintText,
    required this.text,
    required this.icon,
    this.type = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: text,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(icon),
      ),
      keyboardType: type,
      obscureText: obscureText,
    );
  }
}
