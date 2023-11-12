import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/Databases/favorites_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_providers.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/tab_examples.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/tab_video_strokes.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/quizz_details_screen.dart';
import 'package:video_player/video_player.dart';

class KanjiDetails extends ConsumerStatefulWidget {
  const KanjiDetails(
      {super.key, required this.kanjiFromApi, required this.statusStorage});

  final KanjiFromApi kanjiFromApi;
  final StatusStorage statusStorage;

  @override
  ConsumerState<KanjiDetails> createState() => KanjiDetailsState();
}

class KanjiDetailsState extends ConsumerState<KanjiDetails> {
  late bool _favoriteStatus;

  String capitalizeString(String text) {
    var firstLetter = text[0];
    firstLetter = firstLetter.toUpperCase();
    return firstLetter + text.substring(1);
  }

  void stopAnimation() {
    setState(() {
      //if (_videoController.value.isPlaying) _videoController.pause();
    });
  }

  @override
  void initState() {
    super.initState();

    var queryKanji = ref
        .read(favoritesCachedProvider.notifier)
        .searchInFavorites(widget.kanjiFromApi.kanjiCharacter);
    _favoriteStatus = queryKanji != "";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.kanjiFromApi.kanjiCharacter),
          actions: [
            IconButton(
                onPressed: () {
                  ref
                      .read(quizDetailsProvider.notifier)
                      .setDataQuiz(widget.kanjiFromApi);
                  ref.read(quizDetailsProvider.notifier).setQuizState(0);
                  ref.read(selectQuizDetailsProvider.notifier).setScreen(0);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return QuizDetailsScreen(
                          kanjiFromApi: widget.kanjiFromApi);
                    },
                  ));
                },
                icon: const Icon(Icons.quiz)),
            IconButton(
                onPressed: () {
                  final queryKanji = ref
                      .read(favoritesCachedProvider.notifier)
                      .searchInFavorites(widget.kanjiFromApi.kanjiCharacter);

                  if (queryKanji == "") {
                    insertFavorite(widget.kanjiFromApi.kanjiCharacter)
                        .then((value) {
                      final storedItems = ref
                          .read(statusStorageProvider.notifier)
                          .getStoresItems();
                      ref.read(favoritesCachedProvider.notifier).addItem(
                          storedItems.values.fold([], (previousValue, element) {
                            previousValue.addAll(element);
                            return previousValue;
                          }),
                          widget.kanjiFromApi);
                    });
                  } else {
                    deleteFavorite(widget.kanjiFromApi.kanjiCharacter)
                        .then((value) {
                      ref
                          .read(favoritesCachedProvider.notifier)
                          .removeItem(widget.kanjiFromApi);
                    });
                  }

                  setState(() {
                    _favoriteStatus = queryKanji == "";
                  });
                },
                icon: Icon(_favoriteStatus
                    ? Icons.favorite
                    : Icons.favorite_border_outlined))
          ],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.draw),
              ),
              Tab(
                icon: Icon(Icons.play_lesson),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            TabVideoStrokes(
              kanjiFromApi: widget.kanjiFromApi,
              statusStorage: widget.statusStorage,
            ),
            TabExamples(
              kanjiFromApi: widget.kanjiFromApi,
              statusStorage: widget.statusStorage,
              stopAnimation: stopAnimation,
            ),
          ],
        ),
      ),
    );
  }
}
