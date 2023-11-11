import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/Databases/favorites_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_providers.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/examples_audios.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/meaning_definition.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/strokes_images.dart';
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
  late VideoPlayerController _videoController;
  final assetsAudioPlayer = AssetsAudioPlayer();
  late bool _favoriteStatus;

  String capitalizeString(String text) {
    var firstLetter = text[0];
    firstLetter = firstLetter.toUpperCase();
    return firstLetter + text.substring(1);
  }

  List<Widget> getIndexedExamples(
    List<Example> examples,
    void Function() stopAnimation,
  ) {
    List<Widget> indexedExamples = [];
    for (int index = 0; index < examples.length; index++) {
      final tileWidget = ListTile(
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
        trailing: Material(
          child: Ink(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(30)),
            child: InkWell(
              highlightColor: Colors.blue.withOpacity(0.4),
              splashColor: Colors.green.withOpacity(0.5),
              onTap: () {},
              child: IconButton(
                color: Theme.of(context).colorScheme.onPrimary,
                splashColor: Colors.deepOrange,
                onPressed: () async {
                  stopAnimation();

                  final assetsAudioPlayer = AssetsAudioPlayer();

                  try {
                    if (widget.statusStorage == StatusStorage.onlyOnline) {
                      await assetsAudioPlayer.open(
                        Audio.network(examples[index].audio.mp3),
                      );
                    } else if (widget.statusStorage == StatusStorage.stored) {
                      await assetsAudioPlayer.open(
                        Audio.file(examples[index].audio.mp3),
                      );
                    }
                  } catch (t) {
                    //mp3 unreachable
                  }
                },
                icon: const Icon(Icons.play_arrow_rounded),
              ),
            ),
          ),
        ),
      );

      indexedExamples.add(tileWidget);
    }

    return indexedExamples;
  }

  void stopAnimation() {
    setState(() {
      if (_videoController.value.isPlaying) _videoController.pause();
    });
  }

  @override
  void initState() {
    super.initState();

    var queryKanji = ref
        .read(favoritesCachedProvider.notifier)
        .searchInFavorites(widget.kanjiFromApi.kanjiCharacter);
    _favoriteStatus = queryKanji != "";

    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.kanjiFromApi.videoLink))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _videoController.setLooping(true);
          _videoController.play();
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.pause();
    _videoController.dispose();
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
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                _videoController.value.isInitialized
                    ? SizedBox(
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 100 * _videoController.value.aspectRatio,
                              width: 100,
                              child: AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              ),
                            ),
                            Material(
                              child: Ink(
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(30)),
                                child: InkWell(
                                  highlightColor: Colors.blue.withOpacity(0.4),
                                  splashColor: Colors.green.withOpacity(0.5),
                                  onTap: () {},
                                  child: IconButton(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    splashColor: Colors.deepOrange,
                                    onPressed: () async {
                                      setState(() {
                                        _videoController.value.isPlaying
                                            ? _videoController.pause()
                                            : _videoController.play();
                                      });
                                    },
                                    icon: Icon(
                                      _videoController.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height:
                                    128 * _videoController.value.aspectRatio,
                                width: 128,
                                child: const Padding(
                                  padding: EdgeInsets.all(40.0),
                                  child: CircularProgressIndicator(),
                                )),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 4,
                ),
                StrokesImages(
                  kanjiFromApi: widget.kanjiFromApi,
                  statusStorage: widget.statusStorage,
                ),
              ],
            ),
            Column(
              children: [
                MeaningAndDefinition(
                  englishMeaning: widget.kanjiFromApi.englishMeaning,
                  hiraganaMeaning: widget.kanjiFromApi.hiraganaMeaning,
                  katakanaMeaning: widget.kanjiFromApi.katakanaMeaning,
                ),
                const Divider(
                  height: 4,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Examples",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ExampleAudios(
                    examples: widget.kanjiFromApi.example,
                    stopAnimation: stopAnimation,
                    statusStorage: widget.statusStorage,
                  ),
                ),
              ],
            ),
          ],
        ),

/*         Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _videoController.value.isInitialized
                ? SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 100 * _videoController.value.aspectRatio,
                          width: 100,
                          child: AspectRatio(
                            aspectRatio: _videoController.value.aspectRatio,
                            child: VideoPlayer(_videoController),
                          ),
                        ),
                        Material(
                          child: Ink(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(30)),
                            child: InkWell(
                              highlightColor: Colors.blue.withOpacity(0.4),
                              splashColor: Colors.green.withOpacity(0.5),
                              onTap: () {},
                              child: IconButton(
                                color: Theme.of(context).colorScheme.onPrimary,
                                splashColor: Colors.deepOrange,
                                onPressed: () async {
                                  setState(() {
                                    _videoController.value.isPlaying
                                        ? _videoController.pause()
                                        : _videoController.play();
                                  });
                                },
                                icon: Icon(
                                  _videoController.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 128 * _videoController.value.aspectRatio,
                            width: 128,
                            child: const Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(),
                            )),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 4,
            ),
            StrokesImages(
              kanjiFromApi: widget.kanjiFromApi,
              statusStorage: widget.statusStorage,
            ),
            const Divider(
              height: 4,
            ),
            MeaningAndDefinition(
              englishMeaning: widget.kanjiFromApi.englishMeaning,
              hiraganaMeaning: widget.kanjiFromApi.hiraganaMeaning,
              katakanaMeaning: widget.kanjiFromApi.katakanaMeaning,
            ),
            const Divider(
              height: 4,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Examples",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ExampleAudios(
                examples: widget.kanjiFromApi.example,
                stopAnimation: stopAnimation,
                statusStorage: widget.statusStorage,
              ),
            ),
          ],
        ), */
      ),
    );
  }
}
