import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/examples_audios_provider.dart';
import 'package:kanji_for_n5_level_app/providers/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_providers.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
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
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Builder(builder: (BuildContext ctx) {
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
                  IconButton(
                      onPressed: () {
                        ref
                            .read(quizDetailsProvider.notifier)
                            .setDataQuiz(kanjiFromApi);
                        ref.read(quizDetailsProvider.notifier).setQuizState(0);
                        ref
                            .read(selectQuizDetailsProvider.notifier)
                            .setScreen(0);
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
                      icon: Icon(ref.watch(kanjiDetailsProvider)!.favoriteStatus
                          ? Icons.favorite
                          : Icons.favorite_border_outlined))
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
        }));
  }
}
