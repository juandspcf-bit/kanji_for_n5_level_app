import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/example_audio_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/audio_examples_track_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/example_audio_widget_stream/example_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_screen_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_screen_result.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_screens.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/examples_audios.dart';

class SearchScreen extends ConsumerWidget {
  SearchScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  void onValidate(WidgetRef ref) async {
    final currenState = _formKey.currentState;
    if (currenState == null) return;
    if (currenState.validate()) {
      currenState.save();
      return;
    }
    ref.read(searchScreenProvider.notifier).setOnErrorTextField();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchScreenState = ref.watch(searchScreenProvider);
    final statusConnectionState = ref.watch(statusConnectionProvider);

    return Scaffold(
      appBar: AppBar(),
      body: statusConnectionState == ConnectionStatus.noConnected
          ? ErrorConnectionScreen(
              message: context.l10n.searchErrorConnectionMessage,
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        context.l10n.searchMessage,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            initialValue: searchScreenState.word,
                            decoration: const InputDecoration().copyWith(
                              border: const OutlineInputBorder(),
                              suffixIcon: const Icon(Icons.search),
                              hintText: context.l10n.searchEnglishWord,
                            ),
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              final validCharacters = RegExp(r'^[a-zA-Z]+$');
                              if (text != null &&
                                  text.isNotEmpty &&
                                  validCharacters.hasMatch(text.trim())) {
                                return null;
                              } else {
                                return context.l10n.searchInvalidWord;
                              }
                            },
                            onSaved: (value) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => SearchScreenResult(
                                    word: value ?? "",
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: MediaQuery.orientationOf(context) ==
                                    Orientation.portrait
                                ? const Size.fromHeight(50)
                                : const Size(300, 50),
                          ),
                          onPressed: () {
                            onValidate(ref);
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          label: Text(context.l10n.search),
                          icon: const Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
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
                trailing: data.isPlaying
                    ? DummyButtonAudioExample(
                        sizeOval: 50,
                        sizeIcon: 30,
                        trackPlaylist: data.track,
                        indexPlaylist: index,
                        isInPlaylistPlaying: data.isPlaying,
                      )
                    : AudioExampleButtonWidget(
                        audioQuestion: examples[index].audio.mp3,
                        sizeOval: 50,
                        sizeIcon: 30,
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
  const InfoStatusSearch({
    super.key,
    required this.message,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  final String message;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
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
    );
  }
}
