import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/search_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/examples_audios.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/meaning_definition.dart';

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
        return Center(
          child: Text(
            'type a valid word',
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 3,
          ),
        );
      case SearchState.notSearching:
        return Center(
          child: Text(
            'search a kanji by its english meaning',
            style: Theme.of(context).textTheme.titleLarge,
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
            return Center(
              child: Text(
                'The corresponding kanji for this word was not found',
                style: Theme.of(context).textTheme.titleLarge,
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
    final statusConnectionState = ref.watch(statusConnectionProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: statusConnectionState == ConnectivityResult.none
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No internet connection, you will be able to search when the connection is restored',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        color: Colors.amber,
                        size: 80,
                      ),
                    ],
                  )
                ],
              ),
            )
          : Column(
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
                          validCharacters.hasMatch(text)) {
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
            hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
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
