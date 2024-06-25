import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/example_audio_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/examples_audios.dart';

class ExamplesLandscape extends ConsumerWidget {
  const ExamplesLandscape({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiDetailsData = ref.watch(kanjiDetailsProvider);
    final kanjiFromApi = kanjiDetailsData!.kanjiFromApi;
    final statusStorage = kanjiDetailsData.statusStorage;

    final List<AudioExampleButtonWidget> listExampleAudio = [];
    for (int index = 0; index < kanjiFromApi.example.length; index++) {
      listExampleAudio.add(
        AudioExampleButtonWidget(
          audioQuestion: kanjiFromApi.example[index].audio.mp3,
          sizeOval: 50,
          sizeIcon: 30,
          statusStorage: kanjiFromApi.statusStorage,
          onPrimaryColor: Theme.of(context).colorScheme.onPrimary,
        ),
      );
    }

    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "Examples",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: ExampleAudios(
              examples: kanjiFromApi.example,
              statusStorage: statusStorage,
              listAudioExampleButtonWidgets: listExampleAudio,
            ),
          ),
        ],
      ),
    );
  }
}
