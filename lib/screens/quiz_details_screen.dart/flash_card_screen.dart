import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/providers/video_status_playing.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/big_play_button.dart';

class FlassCardScreen extends ConsumerWidget {
  FlassCardScreen({super.key, required this.kanjiFromApi});
  final KanjiFromApi kanjiFromApi;

  final PageController controller = PageController();

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
                  controller: controller,
                  children: [
                    Center(
                      child: BigPlayButton(
                        sizeOval: 90,
                        sizeIcon: 60,
                        onTap: () async {
                          ref
                              .read(videoStatusPlaying.notifier)
                              .setIsPlaying(false);
                          final assetsAudioPlayer = AssetsAudioPlayer();

                          try {
                            if (kanjiFromApi.statusStorage ==
                                StatusStorage.onlyOnline) {
                              await assetsAudioPlayer.open(
                                Audio.network(flashCardState.audioQuestion[
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
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
              controller.jumpToPage(0);
            },
            style: ElevatedButton.styleFrom().copyWith(
              minimumSize: const MaterialStatePropertyAll(
                Size.fromHeight(40),
              ),
            ),
            icon: const Icon(Icons.arrow_circle_right),
            label: Text(ref.read(flashCardProvider.notifier).isTheLastQuestion()
                ? 'Restart the quiz'
                : 'Next'),
          )
        ]),
      ),
    );
  }
}
