import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'password_field_controller.dart';

class AppPasswordField extends StatelessWidget {
  final PasswordFieldController controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool isEnabled;
  final bool isNewPassword;

  const AppPasswordField({
    super.key,
    this.focusNode,
    this.autofocus = true,
    this.isEnabled = true,
    required this.controller,
    required this.isNewPassword,
  });

  Widget _suffix(final BuildContext context) {
    return IconButton(
      splashRadius: 24,
      onPressed: context.watch<PasswordFieldController>().changeVisibility,
      icon: context.watch<PasswordFieldController>().isPasswordVisible
          ? const Icon(Icons.remove_red_eye)
          : const Icon(Icons.remove_red_eye_outlined),
    );
  }

  Widget _passwordField(final BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).cardColor,
      borderRadius: const BorderRadius.all(Radius.circular(14.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 16.0,
        ),
        child: AutofillGroup(
          child: Row(
            children: [
              SizedBox.fromSize(
                size: Size.zero,
                child: Opacity(
                  opacity: 0,
                  child: EditableText(
                    style: const TextStyle(),
                    cursorColor: Colors.transparent,
                    controller: controller._emailController,
                    focusNode: FocusNode(skipTraversal: true),
                    backgroundCursorColor: Colors.transparent,
                    autofillHints: const [AutofillHints.username],
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  enabled: isEnabled,
                  autofocus: autofocus,
                  focusNode: focusNode,
                  style: const TextStyle(height: 1.2),
                  keyboardAppearance: Brightness.dark,
                  key: const ValueKey(#bio_password_field),
                  keyboardType: TextInputType.visiblePassword,
                  autofillHints: [
                    if (isNewPassword)
                      AutofillHints.newPassword
                    else
                      AutofillHints.password,
                  ],
                  controller:
                      context.watch<PasswordFieldController>()._textController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Password',
                  ),
                  obscureText: !context
                      .watch<PasswordFieldController>()
                      .isPasswordVisible,
                ),
              ),
              _suffix(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _passwordField(context),
          ],
        );
      },
    );
  }
}
