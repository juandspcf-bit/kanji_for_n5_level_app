import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_content.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/column_drag_targets.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/draggable_kanji.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/kanji_possible_solution_container.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/score_body.dart';

enum Screens { quiz, score }

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({
    super.key,
    required this.kanjisFromApi,
  });

  final List<KanjiFromApi> kanjisFromApi;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late List<String> imagePathsFromDraggedItems;
  late List<double> initialOpacities;
  late List<bool> isDraggedStatusList;
  late List<bool> isCorrectAnswer;
  late List<bool> isOmittedAnswer;
  late List<bool> isChecked;
  late List<KanjiFromApi> kanjisToAskMeaning;
  late int index;
  late List<KanjiFromApi> randomSolutions;
  late Screens currentScreenType;

  (List<String>, List<double>, List<bool>, List<bool>, List<bool>, List<bool>)
      initLinks(int lenght) {
    final initialLinks = <String>[];
    final initialOpacities = <double>[];
    final isDraggedList = <bool>[];
    final isCorrectAnswerList = <bool>[];
    final isOmittedList = <bool>[];
    final isCheckedList = <bool>[];
    for (int i = 0; i < lenght; i++) {
      initialLinks.add("");
      initialOpacities.add(0.0);
      isDraggedList.add(false);
      isCorrectAnswerList.add(false);
      isOmittedList.add(false);
      isCheckedList.add(false);
    }
    return (
      initialLinks,
      initialOpacities,
      isDraggedList,
      isCorrectAnswerList,
      isOmittedList,
      isCheckedList
    );
  }

  List<KanjiFromApi> suffleData() {
    final copy1 = [...widget.kanjisFromApi];
    copy1.shuffle();
    return copy1;
  }

  List<KanjiFromApi> getPosibleSolutions(KanjiFromApi kanjiToRemove) {
    final copy1 = [...kanjisToAskMeaning];
    copy1.shuffle();
    copy1.remove(kanjiToRemove);
    final copy2 = [kanjiToRemove, ...copy1.sublist(0, 2)];
    copy2.shuffle();
    return copy2;
  }

  void showSnackBarQuizz(String message, int duration) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        content: Text(message),
      ),
    );
  }

  void initTheQuiz() {
    currentScreenType = Screens.quiz;
    kanjisToAskMeaning = suffleData();
    index = 0;
    randomSolutions = getPosibleSolutions(kanjisToAskMeaning[index]);
    final initValues = initLinks(widget.kanjisFromApi.length);
    imagePathsFromDraggedItems = initValues.$1;
    initialOpacities = initValues.$2;
    isDraggedStatusList = initValues.$3;
    isCorrectAnswer = initValues.$4;
    isOmittedAnswer = initValues.$5;
    isChecked = initValues.$6;
  }

  void resetTheQuiz() {
    setState(() {
      initTheQuiz();
    });
  }

  void onDraggedKanji(int i, KanjiFromApi data) {
    setState(() {
      imagePathsFromDraggedItems[i] = data.kanjiImageLink;
      initialOpacities[i] = 1.0;
      isDraggedStatusList[index] = true;
      isCorrectAnswer[index] = randomSolutions[i].kanjiCharacter ==
          kanjisToAskMeaning[index].kanjiCharacter;
      logger.d(isCorrectAnswer[index]);
    });
  }

  @override
  void initState() {
    super.initState();
    initTheQuiz();
  }

  @override
  Widget build(BuildContext context) {
    final resultStatus = ref.watch(statusConnectionProvider);
    var mainAxisAlignment = MainAxisAlignment.start;
    if (resultStatus == ConnectivityResult.none) {
      resetTheQuiz();
      mainAxisAlignment = MainAxisAlignment.center;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Test your knowledge")),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 0,
          bottom: 0,
          right: 30,
          left: 30,
        ),
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            if (resultStatus == ConnectivityResult.none)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'The internet connection has gone, restart the quiz later',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(overflow: TextOverflow.ellipsis),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.amber,
                        size: 80,
                      ),
                    ],
                  )
                ],
              )
            else if (currentScreenType == Screens.score)
              ScoreBody(
                isCorrectAnswer: isCorrectAnswer,
                isOmittedAnswer: isOmittedAnswer,
                resetTheQuiz: resetTheQuiz,
              )
            else
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Question ${index + 1} of ${kanjisToAskMeaning.length}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DraggableKanji(
                            isDragged: isDraggedStatusList[index],
                            kanjiToAskMeaning: kanjisToAskMeaning[index]),
                        ColumnDragTargets(
                            isDragged: isDraggedStatusList[index],
                            randomSolutions: randomSolutions,
                            kanjiToAskMeaning: kanjisToAskMeaning[index],
                            imagePathFromDraggedItem:
                                imagePathsFromDraggedItems,
                            initialOpacitie: initialOpacities,
                            onDraggedKanji: onDraggedKanji)
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          final isDraggedList = <bool>[];
                          final isDraggedImagePath = <String>[];
                          final opacityValues = <double>[];
                          for (int i = 0;
                              i < widget.kanjisFromApi.length;
                              i++) {
                            isDraggedList.add(false);
                            isDraggedImagePath.add("");
                            opacityValues.add(0.0);
                          }
                          setState(() {
                            isDraggedStatusList = [...isDraggedList];
                            isCorrectAnswer = [...isDraggedList];
                            imagePathsFromDraggedItems = [
                              ...isDraggedImagePath
                            ];
                            initialOpacities = [...opacityValues];
                            isChecked[index] = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          minimumSize: Size.fromHeight(
                              (Theme.of(context).textTheme.bodyLarge!.height ??
                                      30) +
                                  10),
                        ),
                        child: const Text("Reset question"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (!isDraggedStatusList[index]) {
                            isOmittedAnswer[index] = true;
                          }
                          if (index < widget.kanjisFromApi.length - 1) {
                            setState(() {
                              index++;
                              randomSolutions = getPosibleSolutions(
                                  kanjisToAskMeaning[index]);
                              final initValues =
                                  initLinks(widget.kanjisFromApi.length);
                              imagePathsFromDraggedItems = initValues.$1;
                              initialOpacities = initValues.$2;
                              isDraggedStatusList = initValues.$3;
                            });
                          } else {
                            setState(() {
                              currentScreenType = Screens.score;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                          minimumSize: Size.fromHeight(
                              (Theme.of(context).textTheme.bodyLarge!.height ??
                                      30) +
                                  10),
                        ),
                        icon: const Icon(Icons.arrow_circle_right),
                        label: const Text('Next'),
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
