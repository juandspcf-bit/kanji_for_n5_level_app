import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class FlassCardScreen extends ConsumerWidget {
  const FlassCardScreen({super.key, required this.kanjiFromApi});
  final KanjiFromApi kanjiFromApi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashCardState = ref.watch(flashCardProvider);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 0,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Question ${flashCardState.indexQuestion + 1} of ${kanjiFromApi.example.length}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: 256,
                height: 512,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.white70,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: PageView(
                  children: [
                    Center(
                      child: ClipOval(
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: Material(
                            color: Theme.of(context).colorScheme.primary,
                            child: InkWell(
                              splashColor: Colors.black38,
                              onTap: () async {
                                final assetsAudioPlayer = AssetsAudioPlayer();

                                try {
                                  if (kanjiFromApi.statusStorage ==
                                      StatusStorage.onlyOnline) {
                                    await assetsAudioPlayer.open(
                                      Audio.network(
                                          flashCardState.audioQuestion[
                                              flashCardState.indexQuestion]),
                                    );
                                  } else if (kanjiFromApi.statusStorage ==
                                      StatusStorage.stored) {
                                    await assetsAudioPlayer.open(
                                      Audio.file(flashCardState.audioQuestion[
                                          flashCardState.indexQuestion]),
                                    );
                                  }
                                } catch (t) {
                                  //mp3 unreachable
                                }
                              },
                              child: Icon(Icons.play_arrow,
                                  size: 60,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            flashCardState
                                .japanese[flashCardState.indexQuestion],
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            flashCardState
                                .english[flashCardState.indexQuestion],
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(flashCardProvider.notifier).incrementIndex();
            },
            style: ElevatedButton.styleFrom().copyWith(
              minimumSize: const MaterialStatePropertyAll(
                Size.fromHeight(40),
              ),
            ),
            icon: const Icon(Icons.arrow_circle_right),
            label: const Text('Next'),
          )
        ]),
      ),
    );
  }
}
