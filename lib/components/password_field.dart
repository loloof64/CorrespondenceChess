import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  const PasswordField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _hidePassword,
      controller: widget.controller,
      decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          suffixIcon: IconButton(
            icon: Icon(
              _hidePassword ? Icons.remove_red_eye : Icons.password,
            ),
            onPressed: () {
              setState(() {
                _hidePassword = !_hidePassword;
              });
            },
          )),
    );
  }
}
