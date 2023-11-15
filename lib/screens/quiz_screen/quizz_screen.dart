import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/internet_connection_error_screen.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/quiz_question_screen.dart';
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
  void showSnackBarQuizz(String message, int duration) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultStatus = ref.watch(statusConnectionProvider);
    final quizState = ref.watch(quizDataValuesProvider);
    var mainAxisAlignment = MainAxisAlignment.start;
    if (resultStatus == ConnectivityResult.none) {
      ref.read(quizDataValuesProvider.notifier).resetTheQuiz();
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
              const InternetConnectionErrorScreen()
            else if (quizState.currentScreenType == Screens.score)
              ScoreBody(
                isCorrectAnswer: quizState.isCorrectAnswer,
                isOmittedAnswer: quizState.isOmittedAnswer,
                resetTheQuiz:
                    ref.read(quizDataValuesProvider.notifier).resetTheQuiz,
              )
            else
              QuizQuestionScreen(
                  isDraggedStatusList: quizState.isDraggedStatusList,
                  randomSolutions: quizState.randomSolutions,
                  kanjisToAskMeaning: quizState.kanjisToAskMeaning,
                  imagePathFromDraggedItems:
                      quizState.imagePathsFromDraggedItems,
                  initialOpacities: quizState.initialOpacities,
                  index: quizState.index,
                  onDraggedKanji:
                      ref.read(quizDataValuesProvider.notifier).onDraggedKanji,
                  onResetQuestion:
                      ref.read(quizDataValuesProvider.notifier).onResetQuestion,
                  onNext: ref.read(quizDataValuesProvider.notifier).onNext)
          ],
        ),
      ),
    );
  }
}
























/* class QuizScreen extends ConsumerStatefulWidget {
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
  late List<KanjiFromApi> kanjisToAskMeaning;
  late int index;
  late List<KanjiFromApi> randomSolutions;
  late Screens currentScreenType;

  (List<String>, List<double>, List<bool>, List<bool>, List<bool>, List<bool>)
      initStateQuiz(int lenght) {
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
    final initValues = initStateQuiz(widget.kanjisFromApi.length);
    imagePathsFromDraggedItems = initValues.$1;
    initialOpacities = initValues.$2;
    isDraggedStatusList = initValues.$3;
    isCorrectAnswer = initValues.$4;
    isOmittedAnswer = initValues.$5;
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
    });
  }

  void onResetQuestion() {
    final isDraggedList = <bool>[];
    final isDraggedImagePath = <String>[];
    final opacityValues = <double>[];
    for (int i = 0; i < widget.kanjisFromApi.length; i++) {
      isDraggedList.add(false);
      isDraggedImagePath.add("");
      opacityValues.add(0.0);
    }
    setState(() {
      isDraggedStatusList = [...isDraggedList];
      isCorrectAnswer = [...isDraggedList];
      imagePathsFromDraggedItems = [...isDraggedImagePath];
      initialOpacities = [...opacityValues];
    });
  }

  void onNext() {
    if (!isDraggedStatusList[index]) {
      isOmittedAnswer[index] = true;
    }
    if (index < widget.kanjisFromApi.length - 1) {
      setState(() {
        index++;
        randomSolutions = getPosibleSolutions(kanjisToAskMeaning[index]);
        final initValues = initStateQuiz(widget.kanjisFromApi.length);
        imagePathsFromDraggedItems = initValues.$1;
        initialOpacities = initValues.$2;
        isDraggedStatusList = initValues.$3;
      });
    } else {
      setState(() {
        currentScreenType = Screens.score;
      });
    }
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
              const InternetConnectionErrorScreen()
            else if (currentScreenType == Screens.score)
              ScoreBody(
                isCorrectAnswer: isCorrectAnswer,
                isOmittedAnswer: isOmittedAnswer,
                resetTheQuiz: resetTheQuiz,
              )
            else
              QuizQuestionScreen(
                  isDraggedStatusList: isDraggedStatusList,
                  randomSolutions: randomSolutions,
                  kanjisToAskMeaning: kanjisToAskMeaning,
                  imagePathFromDraggedItems: imagePathsFromDraggedItems,
                  initialOpacities: initialOpacities,
                  index: index,
                  onDraggedKanji: onDraggedKanji,
                  onResetQuestion: onResetQuestion,
                  onNext: onNext)
          ],
        ),
      ),
    );
  }
}
 */