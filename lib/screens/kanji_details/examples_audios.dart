import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/examples_audios_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class ExampleAudios extends ConsumerWidget {
  const ExampleAudios({
    super.key,
    required this.examples,
    required this.statusStorage,
  });

  final List<Example> examples;
  final StatusStorage statusStorage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(examplesAudiosProvider);

    return Column(
      children: [
        ElevatedButton.icon(
            onPressed: () async {
              if (data.isPlaying) {
                ref.read(examplesAudiosProvider.notifier).stopAudio();
                return;
              }

              ref
                  .read(examplesAudiosProvider)
                  .assetsAudioPlayer
                  .open(
                      Playlist(audios: [
                        for (int index = 0; index < examples.length; index++)
                          if (statusStorage == StatusStorage.onlyOnline)
                            Audio.network(examples[index].audio.mp3)
                          else if (statusStorage == StatusStorage.stored)
                            Audio.file(examples[index].audio.mp3),
                      ]),
                      loopMode: LoopMode.none //loop the full playlist
                      )
                  .then((value) => ref
                      .read(examplesAudiosProvider.notifier)
                      .setIsPlaying(true));
            },
            icon: Icon(data.isPlaying ? Icons.stop : Icons.playlist_play),
            label: const Text('playlist')),
        Expanded(
          child: ListView(
            children: [
              for (int index = 0; index < examples.length; index++)
                ListTile(
                  selected: data.track == index && data.isPlaying,
                  selectedColor: Colors.amberAccent,
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
                  trailing: IconButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.black26),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      final assetsAudioPlayer = AssetsAudioPlayer();

                      try {
                        if (statusStorage == StatusStorage.onlyOnline) {
                          await assetsAudioPlayer.open(
                            Audio.network(examples[index].audio.mp3),
                          );
                        } else if (statusStorage == StatusStorage.stored) {
                          await assetsAudioPlayer.open(
                            Audio.file(examples[index].audio.mp3),
                          );
                        }
                      } catch (t) {
                        //mp3 unreachable
                      }
                    },
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      size: 30,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}
