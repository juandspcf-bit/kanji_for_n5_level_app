import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/quizz_screen.dart';

class QuizDataValuesProvider extends Notifier<QuizDataValues> {
  @override
  QuizDataValues build() {
    final initQuizDataValues = QuizDataValues(
        imagePathsFromDraggedItems: [],
        initialOpacities: [],
        isDraggedStatusList: [],
        isCorrectAnswer: [],
        isOmittedAnswer: [],
        kanjisToAskMeaning: [],
        index: 0,
        randomSolutions: [],
        currentScreenType: Screens.quiz);
    return initQuizDataValues;
  }

  void onNext() {
    if (!state.isDraggedStatusList[state.index]) {
      state.isOmittedAnswer[state.index] = true;
    }

    if (state.index < state.kanjisToAskMeaning.length - 1) {
      final initValues = initStateQuiz(state.kanjisToAskMeaning.length);
      final initQuizDataValues = QuizDataValues(
          imagePathsFromDraggedItems: initValues.$1,
          initialOpacities: initValues.$2,
          isDraggedStatusList: initValues.$3,
          isCorrectAnswer: state.isCorrectAnswer,
          isOmittedAnswer: state.isOmittedAnswer,
          kanjisToAskMeaning: state.kanjisToAskMeaning,
          index: state.index + 1,
          randomSolutions: getPosibleSolutions(state.kanjisToAskMeaning,
              state.kanjisToAskMeaning[state.index + 1]),
          currentScreenType: state.currentScreenType);
      state = initQuizDataValues;
    } else {
      final initQuizDataValues = QuizDataValues(
          imagePathsFromDraggedItems: state.imagePathsFromDraggedItems,
          initialOpacities: state.initialOpacities,
          isDraggedStatusList: state.isDraggedStatusList,
          isCorrectAnswer: state.isCorrectAnswer,
          isOmittedAnswer: state.isOmittedAnswer,
          kanjisToAskMeaning: state.kanjisToAskMeaning,
          index: state.index,
          randomSolutions: state.randomSolutions,
          currentScreenType: Screens.score);
      state = initQuizDataValues;
    }
  }

  void onResetQuestion() {
    final isDraggedList = <bool>[];
    final isDraggedImagePath = <String>[];
    final opacityValues = <double>[];
    for (int i = 0; i < state.kanjisToAskMeaning.length; i++) {
      isDraggedList.add(false);
      isDraggedImagePath.add("");
      opacityValues.add(0.0);
    }

    final initQuizDataValues = QuizDataValues(
        imagePathsFromDraggedItems: [...isDraggedImagePath],
        initialOpacities: [...opacityValues],
        isDraggedStatusList: [...isDraggedList],
        isCorrectAnswer: [...isDraggedList],
        isOmittedAnswer: state.isOmittedAnswer,
        kanjisToAskMeaning: state.kanjisToAskMeaning,
        index: state.index,
        randomSolutions: state.randomSolutions,
        currentScreenType: state.currentScreenType);
    state = initQuizDataValues;
  }

  void onDraggedKanji(int i, KanjiFromApi data) {
    final updatedImagePathsFromDraggedItems = [
      ...state.imagePathsFromDraggedItems
    ];
    updatedImagePathsFromDraggedItems[i] = data.kanjiImageLink;

    final updatedInitialOpacities = [...state.initialOpacities];
    updatedInitialOpacities[i] = 1.0;

    final updatedIsDraggedStatusList = [...state.isDraggedStatusList];
    updatedIsDraggedStatusList[state.index] = true;

    final updatedIsCorrectAnswer = [...state.isCorrectAnswer];
    updatedIsCorrectAnswer[state.index] =
        state.randomSolutions[i].kanjiCharacter ==
            state.kanjisToAskMeaning[state.index].kanjiCharacter;

    final quizDataValues = QuizDataValues(
        imagePathsFromDraggedItems: updatedImagePathsFromDraggedItems,
        initialOpacities: updatedInitialOpacities,
        isDraggedStatusList: updatedIsDraggedStatusList,
        isCorrectAnswer: updatedIsCorrectAnswer,
        isOmittedAnswer: state.isOmittedAnswer,
        kanjisToAskMeaning: state.kanjisToAskMeaning,
        index: state.index,
        randomSolutions: state.randomSolutions,
        currentScreenType: state.currentScreenType);

    state = quizDataValues;
  }

  (List<String>, List<double>, List<bool>, List<bool>, List<bool>)
      initStateQuiz(int lenght) {
    final initialLinks = <String>[];
    final initialOpacities = <double>[];
    final isDraggedList = <bool>[];
    final isCorrectAnswerList = <bool>[];
    final isOmittedList = <bool>[];
    for (int i = 0; i < lenght; i++) {
      initialLinks.add("");
      initialOpacities.add(0.0);
      isDraggedList.add(false);
      isCorrectAnswerList.add(false);
      isOmittedList.add(false);
    }
    return (
      initialLinks,
      initialOpacities,
      isDraggedList,
      isCorrectAnswerList,
      isOmittedList,
    );
  }

  void initTheStateBeforeAccessingQuizScreen(
    int lenght,
    List<KanjiFromApi> kanjisFromApi,
  ) {
    final kanjisToAskMeaning = suffleData(kanjisFromApi);
    const index = 0;
    final randomSolutions = getPosibleSolutions(
      kanjisToAskMeaning,
      kanjisToAskMeaning[index],
    );

    final initState = initStateQuiz(lenght);
    final quizDataValues = QuizDataValues(
        imagePathsFromDraggedItems: initState.$1,
        initialOpacities: initState.$2,
        isDraggedStatusList: initState.$3,
        isCorrectAnswer: initState.$4,
        isOmittedAnswer: initState.$5,
        kanjisToAskMeaning: kanjisToAskMeaning,
        index: index,
        randomSolutions: randomSolutions,
        currentScreenType: Screens.quiz);

    state = quizDataValues;
  }

  void resetTheQuiz() {
    final kanjisToAskMeaning = suffleData(state.kanjisToAskMeaning);
    const index = 0;
    final randomSolutions = getPosibleSolutions(
      kanjisToAskMeaning,
      kanjisToAskMeaning[index],
    );

    final initState = initStateQuiz(kanjisToAskMeaning.length);
    final quizDataValues = QuizDataValues(
        imagePathsFromDraggedItems: initState.$1,
        initialOpacities: initState.$2,
        isDraggedStatusList: initState.$3,
        isCorrectAnswer: initState.$4,
        isOmittedAnswer: initState.$5,
        kanjisToAskMeaning: kanjisToAskMeaning,
        index: index,
        randomSolutions: randomSolutions,
        currentScreenType: Screens.quiz);

    state = quizDataValues;
  }

  List<KanjiFromApi> suffleData(List<KanjiFromApi> kanjisFromApi) {
    final copy1 = [...kanjisFromApi];
    copy1.shuffle();
    return copy1;
  }

  List<KanjiFromApi> getPosibleSolutions(
      List<KanjiFromApi> kanjisToAskMeaning, KanjiFromApi kanjiToRemove) {
    final copy1 = [...kanjisToAskMeaning];
    copy1.shuffle();
    copy1.shuffle();
    copy1.remove(kanjiToRemove);
    final copy2 = [kanjiToRemove, ...copy1.sublist(0, 2)];
    copy2.shuffle();
    return copy2;
  }
}

final quizDataValuesProvider =
    NotifierProvider<QuizDataValuesProvider, QuizDataValues>(
        QuizDataValuesProvider.new);

class QuizDataValues {
  final List<String> imagePathsFromDraggedItems;
  final List<double> initialOpacities;
  final List<bool> isDraggedStatusList;
  final List<bool> isCorrectAnswer;
  final List<bool> isOmittedAnswer;
  final List<KanjiFromApi> kanjisToAskMeaning;
  final int index;
  final List<KanjiFromApi> randomSolutions;
  final Screens currentScreenType;

  QuizDataValues({
    required this.imagePathsFromDraggedItems,
    required this.initialOpacities,
    required this.isDraggedStatusList,
    required this.isCorrectAnswer,
    required this.isOmittedAnswer,
    required this.kanjisToAskMeaning,
    required this.index,
    required this.randomSolutions,
    required this.currentScreenType,
  });
}
