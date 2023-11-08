import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
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
  late List<String> imageLinksFromDraggedItems;
  late List<double> initialOpacities;
  late List<bool> isDraggeInitialList;
  late List<bool> isCorrectAnswer;
  late List<bool> isOmittedAnswer;
  late List<bool> isChecked;
  late List<KanjiFromApi> randomKanjisToAskMeaning;
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
    final copy1 = [...randomKanjisToAskMeaning];
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
    randomKanjisToAskMeaning = suffleData();
    index = 0;
    randomSolutions = getPosibleSolutions(randomKanjisToAskMeaning[index]);
    final initValues = initLinks(widget.kanjisFromApi.length);
    imageLinksFromDraggedItems = initValues.$1;
    initialOpacities = initValues.$2;
    isDraggeInitialList = initValues.$3;
    isCorrectAnswer = initValues.$4;
    isOmittedAnswer = initValues.$5;
    isChecked = initValues.$6;
  }

  void resetTheQuiz() {
    setState(() {
      initTheQuiz();
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
                      'Question ${index + 1} of ${randomKanjisToAskMeaning.length}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isDraggeInitialList[index] == true
                            ? Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                      .withOpacity(0),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(color: Colors.white),
                                ),
                              )
                            : Draggable<KanjiFromApi>(
                                data: randomKanjisToAskMeaning[index],
                                feedback: Text(randomKanjisToAskMeaning[index]
                                    .kanjiCharacter),
                                childWhenDragging: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                        .withOpacity(0),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(color: Colors.white),
                                  ),
                                ),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: randomKanjisToAskMeaning[index]
                                              .statusStorage ==
                                          StatusStorage
                                              .onlyOnline /* ||
                                          (randomKanjisToAskMeaning[index]
                                                  .statusStorage ==
                                              StatusStorage.proccessingStoring || randomKanjisToAskMeaning[index]
                                                  .statusStorage == StatusStorage.proccessingStoringDeleting) */
                                      ? SvgPicture.network(
                                          randomKanjisToAskMeaning[index]
                                              .kanjiImageLink,
                                          height: 70,
                                          width: 70,
                                          semanticsLabel:
                                              randomKanjisToAskMeaning[index]
                                                  .kanjiCharacter,
                                          placeholderBuilder: (BuildContext
                                                  context) =>
                                              Container(
                                                  color: Colors.transparent,
                                                  height: 40,
                                                  width: 40,
                                                  child:
                                                      const CircularProgressIndicator(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            179, 5, 16, 51),
                                                  )),
                                        )
                                      : SvgPicture.file(
                                          File(randomKanjisToAskMeaning[index]
                                              .kanjiImageLink),
                                          height: 70,
                                          width: 70,
                                          semanticsLabel:
                                              randomKanjisToAskMeaning[index]
                                                  .kanjiCharacter,
                                          placeholderBuilder: (BuildContext
                                                  context) =>
                                              Container(
                                                  color: Colors.transparent,
                                                  height: 40,
                                                  width: 40,
                                                  child:
                                                      const CircularProgressIndicator(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            179, 5, 16, 51),
                                                  )),
                                        ),
                                ),
                              ),
                        Column(
                          children: [
                            for (int i = 0; i < randomSolutions.length; i++)
                              Column(
                                children: [
                                  if (isDraggeInitialList[index] == true &&
                                      randomSolutions[i].kanjiCharacter ==
                                          randomKanjisToAskMeaning[index]
                                              .kanjiCharacter &&
                                      imageLinksFromDraggedItems[i] != "")
                                    const Icon(
                                      Icons.done,
                                      color: Colors.amberAccent,
                                      size: 40,
                                    )
                                  else if (isDraggeInitialList[index] == true &&
                                      randomSolutions[i].kanjiCharacter !=
                                          randomKanjisToAskMeaning[index]
                                              .kanjiCharacter &&
                                      imageLinksFromDraggedItems[i] != "")
                                    const Icon(
                                      Icons.close,
                                      color: Colors.amberAccent,
                                      size: 40,
                                    ),
                                  DragTarget<KanjiFromApi>(onAccept: (data) {
                                    setState(() {
                                      imageLinksFromDraggedItems[i] =
                                          data.kanjiImageLink;
                                      initialOpacities[i] = 1.0;
                                      isDraggeInitialList[index] = true;
                                      isCorrectAnswer[index] =
                                          randomSolutions[i].kanjiCharacter ==
                                              randomKanjisToAskMeaning[index]
                                                  .kanjiCharacter;
                                    });
                                  }, builder: (ctx, _, __) {
                                    return Column(
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer
                                                .withOpacity(
                                                    initialOpacities[i]),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: imageLinksFromDraggedItems[
                                                      i] ==
                                                  ''
                                              ? null
                                              : SvgPicture.network(
                                                  imageLinksFromDraggedItems[i],
                                                  height: 70,
                                                  width: 70,
                                                  semanticsLabel:
                                                      randomSolutions[i]
                                                          .kanjiCharacter,
                                                  placeholderBuilder:
                                                      (BuildContext context) =>
                                                          Container(
                                                    color: Colors.transparent,
                                                    height: 70,
                                                    width: 70,
                                                  ),
                                                ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(randomSolutions[i].englishMeaning),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                            'kunyomi: ${randomSolutions[i].hiraganaMeaning}'),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                            'Onyomi: ${randomSolutions[i].katakanaMeaning}'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                          ],
                        ),
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
                          final isDraggegImageLink = <String>[];
                          final opacityValues = <double>[];
                          for (int i = 0;
                              i < widget.kanjisFromApi.length;
                              i++) {
                            isDraggedList.add(false);
                            isDraggegImageLink.add("");
                            opacityValues.add(0.0);
                          }
                          setState(() {
                            isDraggeInitialList = [...isDraggedList];
                            isCorrectAnswer = [...isDraggedList];
                            imageLinksFromDraggedItems = [
                              ...isDraggegImageLink
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
                          if (!isDraggeInitialList[index]) {
                            isOmittedAnswer[index] = true;
                          }
                          if (index < widget.kanjisFromApi.length - 1) {
                            setState(() {
                              index++;
                              randomSolutions = getPosibleSolutions(
                                  randomKanjisToAskMeaning[index]);
                              final initValues =
                                  initLinks(widget.kanjisFromApi.length);
                              imageLinksFromDraggedItems = initValues.$1;
                              initialOpacities = initValues.$2;
                              isDraggeInitialList = initValues.$3;
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
