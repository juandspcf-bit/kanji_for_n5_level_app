import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_quiz_animated.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/icon_favorites.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/tab_examples.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_player_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_strokes/tab_strokes.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_strokes_portrait.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/kanjis_for_section_screen/kanjis_for_section_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/audio_examples_track_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class CustomTabControllerKanjiDetails extends ConsumerWidget {
  const CustomTabControllerKanjiDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Builder(
        builder: (BuildContext ctx) {
          final TabController tabController = DefaultTabController.of(ctx);
          tabController.addListener(() {
            if (tabController.index != 3) {
              ref.read(audioExamplesTrackListProvider).assetsAudioPlayer.stop();
              ref
                  .read(audioExamplesTrackListProvider.notifier)
                  .setIsPlaying(false);
            }
            if (!tabController.indexIsChanging) {
              // Your code goes here.
              // To get index of current tab use tabController.index
            }
          });

          return PopScope(
            onPopInvoked: (didPop) {
              if (!didPop) return;
              ref.read(audioExamplesTrackListProvider).assetsAudioPlayer.stop();
              ref
                  .read(audioExamplesTrackListProvider.notifier)
                  .setIsPlaying(false);
              ref.read(videoPlayerObjectProvider.notifier).setController(null);
            },
            child: const Scaffold(
              appBar: AppBarPortrait(),
              body: TabBarView(
                children: <Widget>[
                  VideoStrokesPortrait(),
                  TabStrokes(),
                  TabExamples(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AppBarPortrait extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarPortrait({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiFromApi = ref.read(kanjiDetailsProvider)!.kanjiFromApi;
    final statusConnectionData = ref.watch(statusConnectionProvider);
    return AppBar(
      title: SelectableText(
        kanjiFromApi.kanjiCharacter,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: statusConnectionData == ConnectionStatus.noConnected
              ? const Icon(Icons.cloud_off)
              : const Icon(Icons.cloud_done_rounded),
        ),
        if (statusConnectionData != ConnectionStatus.noConnected ||
            kanjiFromApi.statusStorage == StatusStorage.stored)
          AnimatedOpacityIcon(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: DetailsQuizScreenAnimated(
                  kanjiFromApi: kanjiFromApi,
                  closedChild: const Icon(Icons.quiz)),
            ),
          ),
        if (statusConnectionData != ConnectionStatus.noConnected)
          AnimatedOpacityIcon(
            child: IconButton(
              onPressed: () {
                ref
                    .read(kanjiDetailsProvider.notifier)
                    .storeToFavorites(kanjiFromApi);
              },
              icon: const IconFavorites(),
            ),
          )
      ],
      bottom: const TabBar(
        tabs: <Widget>[
          Tab(
            icon: Icon(Icons.movie),
          ),
          Tab(
            icon: Icon(Icons.draw),
          ),
          Tab(
            icon: Icon(Icons.play_lesson),
          ),
        ],
      ),
    );
  }
}
