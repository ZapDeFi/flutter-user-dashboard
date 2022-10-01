import 'package:flutter/material.dart';
import 'package:zapdefiapp/presentation/components/password_field/password_field_component.dart';

class PasswordFieldComponent extends StatelessWidget {
  final PasswordFieldController controller;
  final bool autofocus;
  final bool isEnabled;
  final bool isNewPassword;

  const PasswordFieldComponent({
    super.key,
    this.autofocus = true,
    this.isEnabled = true,
    required this.controller,
    required this.isNewPassword,
  });

  @override
  Widget build(BuildContext context) {
    return PasswordFieldComponent(
      controller: controller,
      autofocus: autofocus,
      isEnabled: isEnabled,
      isNewPassword: isNewPassword,
    );
  }
}
