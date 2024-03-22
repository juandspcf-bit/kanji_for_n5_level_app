import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/examples_audios_track_list_provider.dart';
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
    final data = ref.watch(examplesAudiosTrackListProvider);

    return Column(
      children: [
        PlayListButton(
          examples: examples,
          statusStorage: statusStorage,
        ),
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
                      SelectableText(
                        examples[index].japanese,
                        style: data.track == index && data.isPlaying
                            ? Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.amberAccent)
                            : Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                    ],
                  ),
                  subtitle: Column(children: [
                    SelectableText(
                      examples[index].meaning.english,
                      style: data.track == index && data.isPlaying
                          ? Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.amberAccent)
                          : Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                  ]),
                  trailing: Builder(builder: (context) {
                    final assetsAudioPlayer = AssetsAudioPlayer();
                    return IconButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.black26),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () async {
                        await assetsAudioPlayer.stop();
                        if (data.isPlaying) return;
                        if (data.track == index && data.isPlaying) return;
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
                      icon: data.track == index && data.isPlaying
                          ? Icon(
                              Icons.music_note,
                              size: 30,
                              color: Theme.of(context).colorScheme.onPrimary,
                            )
                          : StreamBuilder(
                              stream: assetsAudioPlayer.isPlaying,
                              builder: (context, asyncSnapshot) {
                                if (asyncSnapshot.data == null) {
                                  return Icon(
                                    Icons.play_arrow_rounded,
                                    size: 30,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  );
                                }
                                final bool isPlaying = asyncSnapshot.data!;
                                return Icon(
                                  isPlaying
                                      ? Icons.music_note
                                      : Icons.play_arrow_rounded,
                                  size: 30,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                );
                              }),
                    );
                  }),
                )
            ],
          ),
        )
      ],
    );
  }
}

class PlayListButton extends ConsumerWidget {
  const PlayListButton({
    super.key,
    required this.examples,
    required this.statusStorage,
  });

  final List<Example> examples;
  final StatusStorage statusStorage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(examplesAudiosTrackListProvider);
    return ElevatedButton.icon(
        onPressed: data.isPlaying
            ? null
            : () async {
                ref
                    .read(examplesAudiosTrackListProvider)
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
                        .read(examplesAudiosTrackListProvider.notifier)
                        .setIsPlaying(true));
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          textStyle: Theme.of(context).textTheme.bodyLarge,
        ),
        icon: Icon(data.isPlaying ? Icons.stop : Icons.playlist_play),
        label: const Text('playlist'));
  }
}
