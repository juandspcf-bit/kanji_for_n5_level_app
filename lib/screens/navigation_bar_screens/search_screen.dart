import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/search_screen_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class SearchScreen extends ConsumerWidget {
  SearchScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final validCharacters = RegExp(r'^[a-zA-Z]+$');

  void onValidate(WidgetRef ref) async {
    final currenState = _formKey.currentState;
    if (currenState == null) return;
    if (currenState.validate()) {
      currenState.save();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration().copyWith(
                  border: const OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                    child: const Icon(Icons.search),
                    onTap: () {
                      logger.d('clicked');
                      onValidate(ref);
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                  labelText: 'english word',
                  hintText: 'english word'),
              keyboardType: TextInputType.text,
              validator: (text) {
                if (text != null &&
                    text.isNotEmpty &&
                    validCharacters.hasMatch(text)) {
                  return null;
                } else {
                  return 'Not a valid word';
                }
              },
              onSaved: (value) {
                ref.read(searchScreenProvider.notifier).setWord(value ?? '');
              },
            ),
          )
        ],
      ),
    );
  }
}
