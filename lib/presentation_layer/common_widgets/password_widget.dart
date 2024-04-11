import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.initialValue,
    required this.onSave,
    required this.formKey,
    required this.labelText,
  });

  final GlobalKey<FormState> formKey;
  final String initialValue;
  final void Function(String? text) onSave;
  final String labelText;

  @override
  State<PasswordTextField> createState() {
    return _PasswordTextField();
  }
}

class _PasswordTextField extends State<PasswordTextField> {
  late bool isPasswordVisible;

  @override
  void initState() {
    isPasswordVisible = false;
    logger.d('in initState $isPasswordVisible');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      decoration: const InputDecoration().copyWith(
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.key),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              final currentState = widget.formKey.currentState;

              if (currentState == null) {
                return;
              }

              setState(() {
                isPasswordVisible = !isPasswordVisible;
                logger.d(isPasswordVisible);
              });
            },
            child: isPasswordVisible
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          ),
        ),
        labelText: widget.labelText,
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: !isPasswordVisible,
      validator: (text) {
        if (text != null && text.length >= 4 && text.length <= 20) {
          return null;
        } else {
          return 'Password should be between 20 and 4 characters';
        }
      },
      onSaved: (value) {
        widget.onSave(value);
      },
    );
  }
}
