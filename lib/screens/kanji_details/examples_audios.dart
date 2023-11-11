import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class ExampleAudios extends ConsumerWidget {
  const ExampleAudios({
    super.key,
    required this.examples,
    required this.stopAnimation,
    required this.statusStorage,
  });

  final List<Example> examples;
  final void Function() stopAnimation;
  final StatusStorage statusStorage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              for (int index = 0; index < examples.length; index++)
                ListTile(
                  leading: Text(
                    '${index + 1}._',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  title: Column(
                    children: [
                      Text(examples[index].japanese),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(examples[index].meaning.english),
                      const SizedBox(
                        height: 7,
                      ),
                    ],
                  ),
                  trailing: Material(
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(30)),
                      child: InkWell(
                        highlightColor: Colors.blue.withOpacity(0.4),
                        splashColor: Colors.green.withOpacity(0.5),
                        onTap: () {},
                        child: IconButton(
                          color: Theme.of(context).colorScheme.onPrimary,
                          splashColor: Colors.deepOrange,
                          onPressed: () async {
                            stopAnimation();

                            final assetsAudioPlayer = AssetsAudioPlayer();

                            try {
                              if (statusStorage == StatusStorage.onlyOnline) {
                                await assetsAudioPlayer.open(
                                  Audio.network(examples[index].audio.mp3),
                                );
                              } else if (statusStorage ==
                                  StatusStorage.stored) {
                                await assetsAudioPlayer.open(
                                  Audio.file(examples[index].audio.mp3),
                                );
                              }
                            } catch (t) {
                              //mp3 unreachable
                            }
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}
