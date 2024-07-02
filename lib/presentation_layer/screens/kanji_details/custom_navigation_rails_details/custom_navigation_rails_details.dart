import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/custom_navigation_rails_details/custom_navigation_rails_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/landscape_screens/examples_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/landscape_screens/options.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/landscape_screens/strokes.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/audio_examples_track_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_player_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_strokes_landscape.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:video_player/video_player.dart';

class CustomNavigationRailKanjiDetails extends ConsumerWidget {
  const CustomNavigationRailKanjiDetails({
    super.key,
    required this.kanjiFromApi,
  });

  final KanjiFromApi kanjiFromApi;

  Widget getSelection(
    int selection,
    KanjiFromApi kanjiFromApi,
  ) {
    if (selection == 0) {
      return const VideoStrokesLandScape();
    } else if (selection == 1) {
      return const StrokesLandScape();
    } else if (selection == 2) {
      return const ExamplesLandscape();
    } else {
      return OptionsDetails(
        kanjiFromApi: kanjiFromApi,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customNavigationRailsDetailsData =
        ref.watch(customNavigationRailsDetailsProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        if (!didPop) return;
        ref.read(audioExamplesTrackListProvider).assetsAudioPlayer.stop();
        ref.read(audioExamplesTrackListProvider.notifier).setIsPlaying(false);
        ref.read(videoPlayerObjectProvider.notifier).setController(null);
      },
      child: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: customNavigationRailsDetailsData.selection,
              groupAlignment: 0.0,
              onDestinationSelected: (int selection) {
                ref
                    .read(customNavigationRailsDetailsProvider.notifier)
                    .setSelection(selection);

                if (selection == 0) {
                  VideoPlayerController videoController;

                  if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
                    videoController = VideoPlayerController.networkUrl(
                        Uri.parse(kanjiFromApi.videoLink));
                  } else {
                    videoController = VideoPlayerController.file(
                        File(kanjiFromApi.videoLink));
                  }

                  ref
                      .read(videoPlayerObjectProvider.notifier)
                      .setController(videoController);
                }
              },
              labelType: NavigationRailLabelType.none,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.movie),
                  label: Text('movie'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.draw),
                  label: Text('draw'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.play_lesson),
                  label: Text('Play lesson'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.menu),
                  label: Text('options'),
                ),
              ],
            ),
            Expanded(
                child: getSelection(
              customNavigationRailsDetailsData.selection,
              kanjiFromApi,
            )),
          ],
        ),
      ),
    );
  }
}
