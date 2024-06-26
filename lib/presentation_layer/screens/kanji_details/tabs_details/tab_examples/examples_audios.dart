import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/example_audio_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/example_audio_widget_stream/example_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/audio_examples_track_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class ExampleAudios extends ConsumerWidget {
  const ExampleAudios({
    super.key,
    required this.examples,
    required this.statusStorage,
    required this.listAudioExampleButtonWidgets,
    this.physics,
  });

  final List<Example> examples;
  final StatusStorage statusStorage;
  final ScrollPhysics? physics;
  final List<AudioExampleButtonWidget> listAudioExampleButtonWidgets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(audioExamplesTrackListProvider);
    return Column(
      children: [
        PlayListButton(
          examples: examples,
          statusStorage: statusStorage,
        ),
        Expanded(
          child: ListView(
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
                      : listAudioExampleButtonWidgets[index],
                )
            ],
          ),
        )
      ],
    );
  }
}

class SubTitleListTileExample extends StatelessWidget {
  const SubTitleListTileExample({
    super.key,
    required this.examples,
    required this.index,
    required this.data,
  });

  final List<Example> examples;
  final int index;
  final AudioExamplesTrackListData data;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
    ]);
  }
}

class TitleListTileExample extends StatelessWidget {
  const TitleListTileExample({
    super.key,
    required this.examples,
    required this.index,
    required this.data,
  });

  final List<Example> examples;
  final int index;
  final AudioExamplesTrackListData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectableText(
          examples[index].japanese,
          style: data.track == index && data.isPlaying
              ? Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold, color: Colors.amberAccent)
              : Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 7,
        ),
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
    final data = ref.watch(audioExamplesTrackListProvider);
    return ElevatedButton.icon(
        onPressed: data.isPlaying
            ? null
            : () async {
                ref
                    .read(audioExamplesTrackListProvider)
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
                        .read(audioExamplesTrackListProvider.notifier)
                        .setIsPlaying(true));
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          textStyle: Theme.of(context).textTheme.bodyLarge,
        ),
        icon: Icon(data.isPlaying ? Icons.stop : Icons.playlist_play),
        label: Text(context.l10n.playlist));
  }
}
