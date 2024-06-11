import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/svg_utils/svg_utils.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/example_audio_widget_stream/example_audio_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/examples_audios.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/meaning_definition.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/slivers_version/sliver_sub_header.dart';
import 'package:kanji_for_n5_level_app/providers/examples_audios_track_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/search_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class MySliver extends ConsumerWidget {
  const MySliver({
    super.key,
    required this.kanjiFromApi,
    required this.examples,
    required this.statusStorage,
    this.physics,
  });
  final KanjiFromApi? kanjiFromApi;
  final List<Example>? examples;
  final StatusStorage? statusStorage;
  final ScrollPhysics? physics;

  Widget getResult(SearchState searchState, KanjiFromApi? kanjiFromApi,
      BuildContext context) {
    switch (searchState) {
      case SearchState.errorForm:
        return const InfoStatusSearch(message: 'type a valid word');
      case SearchState.notSearching:
        return const InfoStatusSearch(
            message: 'search a kanji by its english meaning');
      case SearchState.searching:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case SearchState.stoped:
        {
          if (kanjiFromApi == null) {
            return const InfoStatusSearch(
                message: 'The corresponding kanji for this word was not found');
          }
          return MySliver(
            kanjiFromApi: kanjiFromApi,
            examples: kanjiFromApi.example,
            statusStorage: kanjiFromApi.statusStorage,
          ); //Results(kanjiFromApi: kanjiFromApi);
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(examplesAudiosTrackListProvider);
    final searchScreenState = ref.watch(searchScreenProvider);
    final statusConnectionState = ref.watch(statusConnectionProvider);
    return CustomScrollView(
      slivers: [
        const SliverPadding(padding: EdgeInsets.only(top: 20, bottom: 20)),
        SliverSubHeader(
          text: "heyyyy",
          backgroundColor: Colors.purple,
        ),
        if (SearchState.stoped == searchScreenState.searchState &&
            kanjiFromApi != null)
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: SvgNetwork(
                imageUrl: kanjiFromApi!.strokes.images.last,
                semanticsLabel: kanjiFromApi!.kanjiCharacter,
              ),
            ),
          ),
        if (SearchState.stoped == searchScreenState.searchState &&
            kanjiFromApi != null)
          SliverToBoxAdapter(
            child: MeaningAndDefinition(
              englishMeaning: kanjiFromApi!.englishMeaning,
              hiraganaRomaji: kanjiFromApi!.hiraganaRomaji,
              hiraganaMeaning: kanjiFromApi!.hiraganaMeaning,
              katakanaRomaji: kanjiFromApi!.katakanaRomaji,
              katakanaMeaning: kanjiFromApi!.katakanaMeaning,
            ),
          ),
        if (SearchState.stoped == searchScreenState.searchState &&
            examples != null &&
            statusStorage != null)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                selected: data.track == index && data.isPlaying,
                selectedColor: Colors.amberAccent,
                leading: Text(
                  '${index + 1}._',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                title: TitleListTileExample(
                  examples: examples!,
                  index: index,
                  data: data,
                ),
                subtitle: SubTitleListTileExample(
                  examples: examples!,
                  index: index,
                  data: data,
                ),
                trailing: ExampleAudioStream(
                  audioQuestion: examples![index].audio.mp3,
                  sizeOval: 50,
                  sizeIcon: 30,
                  trackPlaylist: data.track,
                  indexPlaylist: index,
                  isInPlaylistPlaying: data.isPlaying,
                  statusStorage: statusStorage!,
                  onPrimaryColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              childCount: examples!.length,
            ),
          ),
      ],
    );
  }
}
