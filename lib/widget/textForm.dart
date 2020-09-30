import 'package:flutter/material.dart';

class TextFormCustom extends StatelessWidget {
  final String label;
  final String hint;
  final bool password;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;

  TextFormCustom(
      this.label,
      this.hint,
      {
        this.password = false,
        this.controller,
        this.validator,
        this.keyboardType
      }
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        obscureText: password,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(fontSize: 18, color: Colors.blue),
        decoration: InputDecoration(
            labelText: label,
            hintText: hint
        )
    );
  }
}
