import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
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

  Widget getResult(SearchState searchState, KanjiFromApi? kanjiFromApi) {
    switch (searchState) {
      case SearchState.notSearching:
        return const Center(
          child: Text(
            'search a kanji by its english meaning',
            maxLines: 3,
          ),
        );
      case SearchState.searching:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case SearchState.stoped:
        {
          if (kanjiFromApi != null) {
            return Center(
              child: Text(kanjiFromApi.kanjiCharacter),
            );
          } else {
            return const Center(
              child: Text(
                'The corresponding kanji for this word was not found',
                maxLines: 3,
              ),
            );
          }
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchScreenState = ref.watch(searchScreenProvider);
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
          ),
          const SizedBox(
            height: 20,
          ),
          getResult(
              searchScreenState.searchState, searchScreenState.kanjiFromApi)
        ],
      ),
    );
  }
}
