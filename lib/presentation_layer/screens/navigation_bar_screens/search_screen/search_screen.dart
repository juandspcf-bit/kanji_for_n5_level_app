import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/svg_utils/svg_utils.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/example_audio_widget_stream/example_audio_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/audio_examples_track_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/meaning_search.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_screens.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/examples_audios.dart';

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
        return Padding(
          padding: const EdgeInsets.only(top: 90),
          child: InfoStatusSearch(message: context.l10n.searchInvalidWord),
        );
      case SearchState.notSearching:
        return Padding(
          padding: const EdgeInsets.only(top: 90),
          child: InfoStatusSearch(message: context.l10n.searchMessage),
        );
      case SearchState.searching:
        return const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 90),
            child: CircularProgressIndicator(),
          ),
        );
      case SearchState.stopped:
        {
          if (kanjiFromApi == null) {
            return Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: InfoStatusSearch(
                  message: context.l10n.searchMeaningWasNotFound),
            );
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
        ? ErrorConnectionScreen(
            message: context.l10n.searchErrorConnectionMessage,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
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
                          hintText: context.l10n.searchEnglishWord,
                        ),
                        keyboardType: TextInputType.text,
                        validator: (text) {
                          if (text != null &&
                              text.isNotEmpty &&
                              validCharacters.hasMatch(text.trim())) {
                            return null;
                          } else {
                            return context.l10n.searchInvalidWord;
                          }
                        },
                        onSaved: (value) {
                          ref
                              .read(searchScreenProvider.notifier)
                              .setWord(value ?? '');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  getResult(searchScreenState.searchState,
                      searchScreenState.kanjiFromApi, context)
                ],
              ),
            ),
          );
  }
}

class Results extends ConsumerWidget {
  const Results({super.key, required this.kanjiFromApi});
  final KanjiFromApi kanjiFromApi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: SvgNetwork(
              imageUrl: kanjiFromApi.strokes.images.last,
              semanticsLabel: kanjiFromApi.kanjiCharacter,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MeaningSearch(
            englishMeaning: kanjiFromApi.englishMeaning,
            hiraganaRomaji: kanjiFromApi.hiraganaRomaji,
            hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
            katakanaRomaji: kanjiFromApi.katakanaRomaji,
            katakanaMeaning: kanjiFromApi.katakanaMeaning,
          ),
          const SizedBox(
            height: 20,
          ),
          ExampleAudiosSearch(
            examples: kanjiFromApi.example,
            statusStorage: StatusStorage.onlyOnline,
            physics: const NeverScrollableScrollPhysics(),
          ) /**/
        ],
      ),
    );
  }
}

class ExampleAudiosSearch extends ConsumerWidget {
  const ExampleAudiosSearch({
    super.key,
    required this.examples,
    required this.statusStorage,
    this.physics,
  });

  final List<Example> examples;
  final StatusStorage statusStorage;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(audioExamplesTrackListProvider);
    return Column(
      children: [
        PlayListButton(
          examples: examples,
          statusStorage: statusStorage,
        ),
        ListView(
          shrinkWrap: true,
          physics: physics,
          children: [
            for (int index = 0; index < examples.length; index++)
              ListTile(
                selected: data.track == index && data.isPlaying,
                selectedColor: Colors.amberAccent,
                leading: Text(
                  '${index + 1}._',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                title: TitleListTileExample(
                  examples: examples,
                  index: index,
                  data: data,
                ),
                subtitle: SubTitleListTileExample(
                  examples: examples,
                  index: index,
                  data: data,
                ),
                trailing: ExampleAudioStream(
                  audioQuestion: examples[index].audio.mp3,
                  sizeOval: 50,
                  sizeIcon: 30,
                  trackPlaylist: data.track,
                  indexPlaylist: index,
                  isInPlaylistPlaying: data.isPlaying,
                  statusStorage: statusStorage,
                  onPrimaryColor: Theme.of(context).colorScheme.onPrimary,
                ),
              )
          ],
        )
      ],
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
