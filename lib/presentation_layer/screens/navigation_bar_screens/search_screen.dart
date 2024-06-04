import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/search_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_connection_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/tab_examples/examples_audios.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/tab_media/meaning_definition.dart';

class SearchScreen extends ConsumerWidget {
  SearchScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final validCharacters = RegExp(r'^[a-zA-Z]+$');

  void onValidate(WidgetRef ref) async {
    final currenState = _formKey.currentState;
    if (currenState == null) return;
    if (currenState.validate()) {
      currenState.save();
      return;
    }
    ref.read(searchScreenProvider.notifier).setOnErrorTextField();
  }

  Widget getResult(SearchState searchState, KanjiFromApi? kanjiFromApi,
      BuildContext context) {
    switch (searchState) {
      case SearchState.errorForm:
        return const InfoStatusSearch(message: 'type a valid word');
      case SearchState.notSearching:
        return const InfoStatusSearch(
            message: 'search a kanji by its english meaning');
      case SearchState.searching:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case SearchState.stoped:
        {
          if (kanjiFromApi == null) {
            return const InfoStatusSearch(
                message: 'The corresponding kanji for this word was not found');
          }
          return Results(kanjiFromApi: kanjiFromApi);
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchScreenState = ref.watch(searchScreenProvider);
    final statusConnectionState = ref.watch(statusConnectionProvider);
    return statusConnectionState == ConnectionStatus.noConnected
        ? const ErrorConnectionScreen(
            message:
                'No internet connection, you will be able to search when the connection is restored',
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                            onValidate(ref);
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

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
                          validCharacters.hasMatch(text.trim())) {
                        return null;
                      } else {
                        return 'Not a valid word';
                      }
                    },
                    onSaved: (value) {
                      ref
                          .read(searchScreenProvider.notifier)
                          .setWord(value ?? '');
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: getResult(searchScreenState.searchState,
                      searchScreenState.kanjiFromApi, context),
                )
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
            hiraganaRomaji: kanjiFromApi.hiraganaRomaji,
            hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
            katakanaRomaji: kanjiFromApi.katakanaRomaji,
            katakanaMeaning: kanjiFromApi.katakanaMeaning,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ExampleAudios(
              examples: kanjiFromApi.example,
              statusStorage: StatusStorage.onlyOnline,
            ),
          )
        ],
      ),
    );
  }
}

class InfoStatusSearch extends StatelessWidget {
  const InfoStatusSearch({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
