import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/examples_audios_provider.dart';
import 'package:kanji_for_n5_level_app/providers/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_providers.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/tab_examples.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/tab_strokes.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/tab_video_strokes.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/quizz_details_screen.dart';

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

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Builder(
        builder: (BuildContext ctx) {
          final TabController tabController = DefaultTabController.of(ctx);
          tabController.addListener(() {
            if (tabController.index != 3) {
              ref.read(examplesAudiosProvider).assetsAudioPlayer.stop();
              ref.read(examplesAudiosProvider.notifier).setIsPlaying(false);
            }
            if (!tabController.indexIsChanging) {
              // Your code goes here.
              // To get index of current tab use tabController.index
            }
          });

          return PopScope(
            onPopInvoked: (didPop) {
              if (!didPop) return;
              ref.read(examplesAudiosProvider).assetsAudioPlayer.stop();
              ref.read(examplesAudiosProvider.notifier).setIsPlaying(false);
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(kanjiFromApi.kanjiCharacter),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: statusConnectionData == ConnectivityResult.none
                        ? const Icon(Icons.cloud_off)
                        : const Icon(Icons.cloud_done_rounded),
                  ),
                  IconButton(
                      onPressed: () {
                        ref
                            .read(quizDetailsProvider.notifier)
                            .setDataQuiz(kanjiFromApi);
                        ref.read(quizDetailsProvider.notifier).setQuizState(0);
                        ref
                            .read(selectQuizDetailsProvider.notifier)
                            .setScreen(ScreensQuizDetail.welcome);
                        ref
                            .read(selectQuizDetailsProvider.notifier)
                            .setOption(2);
                        ref
                            .read(flashCardProvider.notifier)
                            .initTheQuiz(kanjiFromApi);

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return QuizDetailsScreen(
                                kanjiFromApi: kanjiFromApi);
                          },
                        ));
                      },
                      icon: const Icon(Icons.quiz)),
                  IconButton(
                    onPressed: () {
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
