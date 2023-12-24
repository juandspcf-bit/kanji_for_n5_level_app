import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailTextField extends ConsumerWidget {
  const EmailTextField(
      {super.key, required this.initialValue, required this.setEmail});

  final String initialValue;
  final void Function(String? value) setEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      initialValue: initialValue,
      decoration: const InputDecoration().copyWith(
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.email),
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (text) {
        if (text != null && EmailValidator.validate(text)) {
          return null;
        } else {
          return 'Not a valid email';
        }
      },
      onSaved: setEmail,
    );
  }
}
