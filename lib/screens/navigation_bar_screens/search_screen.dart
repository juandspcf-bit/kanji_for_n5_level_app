import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/search_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/examples_audios.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/meaning_definition.dart';
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
            return Results(kanjiFromApi: kanjiFromApi);
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
              initialValue: searchScreenState.word,
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

class Results extends ConsumerWidget {
  const Results({super.key, required this.kanjiFromApi});
  final KanjiFromApi kanjiFromApi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: SvgPicture.network(
                kanjiFromApi.strokes.images.last,
                height: 80,
                width: 80,
                semanticsLabel: kanjiFromApi.kanjiCharacter,
                placeholderBuilder: (BuildContext context) => Container(
                    color: Colors.transparent,
                    height: 40,
                    width: 40,
                    child: const CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(179, 5, 16, 51),
                    )),
              ),
            ),
            MeaningAndDefinition(
                englishMeaning: kanjiFromApi.englishMeaning,
                hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
                katakanaMeaning: kanjiFromApi.katakanaMeaning),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
