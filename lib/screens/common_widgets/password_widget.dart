import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    required this.initialValue,
    required this.onSave,
    required this.onToggleVisibility,
    required this.isPasswordVisible,
  });

  final String initialValue;
  final void Function(String? text) onSave;
  final Function() onToggleVisibility;
  final bool isPasswordVisible;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: const InputDecoration().copyWith(
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.key),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              onToggleVisibility();
            },
            child: isPasswordVisible
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          ),
        ),
        labelText: 'Password',
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
        onSave(value);
      },
    );
  }
}

/* class PasswordTextFieldProvider extends Notifier<PasswordTextFieldData> {
  @override
  build() {
    return PasswordTextFieldData(isPaswwordVisible: false);
  }

  void toggleVisibility() {

  }
}

final passwordTextFieldProvider =
    NotifierProvider<PasswordTextFieldProvider, PasswordTextFieldData>(
        PasswordTextFieldProvider.new);

class PasswordTextFieldData {
  final bool isPaswwordVisible;

  PasswordTextFieldData({required this.isPaswwordVisible});
} */
