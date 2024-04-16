import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_quiz_animated.dart';
import 'package:kanji_for_n5_level_app/providers/examples_audios_track_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/custom_navigation_rails_details/custom_navigation_rails_details.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/flash_card/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/last_score_flash_card_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/tab_examples.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/tab_strokes.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/tab_video_strokes.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/details_quizz_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/last_score_details_provider.dart';

class KanjiDetails extends ConsumerWidget {
  const KanjiDetails(
      {super.key, required this.kanjiFromApi, required this.statusStorage});

  final KanjiFromApi kanjiFromApi;
  final StatusStorage statusStorage;

  String capitalizeString(String text) {
    var firstLetter = text[0];
    firstLetter = firstLetter.toUpperCase();
    return firstLetter + text.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final sizeScreen = getScreenSizeWidth(context);
    bool tabedScreen = true;
    switch ((orientation, sizeScreen)) {
      case (Orientation.landscape, _):
        {
          tabedScreen = false;
        }
      case (_, ScreenSizeWidth.extraLarge):
        tabedScreen = true;
      case (_, ScreenSizeWidth.large):
        tabedScreen = true;
      case (_, _):
        tabedScreen = true;
    }

    final statusConnectionData = ref.watch(statusConnectionProvider);

    ref.listen<KanjiDetailsData?>(kanjiDetailsProvider, (prev, current) {
      if (current!.storingToFavoritesStatus ==
              StoringToFavoritesStatus.successAdded ||
          current.storingToFavoritesStatus ==
              StoringToFavoritesStatus.successRemoved ||
          current.storingToFavoritesStatus == StoringToFavoritesStatus.error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        var snackBar = SnackBar(
          content: Text(current.storingToFavoritesStatus.message),
          duration: const Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        ref
            .read(kanjiDetailsProvider.notifier)
            .setStoringToFavoritesStatus(StoringToFavoritesStatus.noStarted);
      }
    });

    return tabedScreen
        ? DefaultTabController(
            initialIndex: 0,
            length: 3,
            child: Builder(
              builder: (BuildContext ctx) {
                final TabController tabController =
                    DefaultTabController.of(ctx);
                tabController.addListener(() {
                  if (tabController.index != 3) {
                    ref
                        .read(examplesAudiosTrackListProvider)
                        .assetsAudioPlayer
                        .stop();
                    ref
                        .read(examplesAudiosTrackListProvider.notifier)
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
                    ref
                        .read(examplesAudiosTrackListProvider)
                        .assetsAudioPlayer
                        .stop();
                    ref
                        .read(examplesAudiosTrackListProvider.notifier)
                        .setIsPlaying(false);
                    ScaffoldMessenger.of(context).clearSnackBars();
                  },
                  child: Scaffold(
                    appBar: AppBar(
                      title: SelectableText(
                        kanjiFromApi.kanjiCharacter,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: statusConnectionData == ConnectivityResult.none
                              ? const Icon(Icons.cloud_off)
                              : const Icon(Icons.cloud_done_rounded),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: KanjiDetailsQuizAnimated(
                              kanjiFromApi: kanjiFromApi,
                              closedChild: const Icon(Icons.quiz)),
                        ),
                        IconButton(
                          onPressed:
                              statusConnectionData == ConnectivityResult.none
                                  ? null
                                  : () {
                                      ref
                                          .read(kanjiDetailsProvider.notifier)
                                          .storeToFavorites(kanjiFromApi);
                                    },
                          icon: const IconFavorites(),
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
                    ),
                    body: const TabBarView(
                      children: <Widget>[
                        TabVideoStrokes(),
                        TabStrokes(),
                        TabExamples(),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : CustomNavigationRailKanjiDetails(
            kanjiFromApi: kanjiFromApi,
          );
  }
}

class IconFavorites extends ConsumerWidget {
  const IconFavorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiDetailsData = ref.watch(kanjiDetailsProvider);
    return Builder(
      builder: (context) {
        if (kanjiDetailsData!.storingToFavoritesStatus ==
            StoringToFavoritesStatus.processing) {
          return LayoutBuilder(
            builder: (ctx, constrains) {
              final height = constrains.maxHeight;
              logger.d(height);
              return SizedBox(
                width: height - 15,
                height: height - 15,
                child: const CircularProgressIndicator(),
              );
            },
          );
        }

        return Icon(kanjiDetailsData.favoriteStatus
            ? Icons.favorite
            : Icons.favorite_border_outlined);
      },
    );
  }
}
