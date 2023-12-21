import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PassworChange extends ConsumerWidget {
  PassworChange({super.key});

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text('Change your password',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(
          height: 40,
        ),
        Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('password'),
                    suffixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('confirm your password'),
                    suffixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text('change your password'),
                ),
              ],
            ))
      ],
    );
  }
}
