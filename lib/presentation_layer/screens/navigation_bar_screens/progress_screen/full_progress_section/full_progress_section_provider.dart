import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/models/quiz_section_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_section_data.dart';

class FullProgressSectionProvider extends Notifier<FullProgressSectionData> {
  @override
  FullProgressSectionData build() {
    final kanjisQuizData = SingleQuizSectionData(
      section: -1,
      allCorrectAnswers: false,
      isFinishedQuiz: false,
      countCorrects: 0,
      countIncorrect: 0,
      countOmitted: 0,
    );

    return FullProgressSectionData(
      fetchingDataStatus: FetchingDataStatus.notFetching,
      quizSectionData: QuizSectionData(
        singleQuizSectionData: kanjisQuizData,
        singleQuizFlashCardData: [],
        singleAudioExampleQuizData: [],
      ),
    );
  }

  void fetchData(int section) async {
    state = FullProgressSectionData(
      fetchingDataStatus: FetchingDataStatus.fetching,
      quizSectionData: state.quizSectionData,
    );

    final quizSectionData =
        await ref.read(localDBServiceProvider).getQuizSectionDataFromDB(
              ref.read(authServiceProvider).userUuid ?? '',
              section,
            );

    state = FullProgressSectionData(
      fetchingDataStatus: FetchingDataStatus.notFetching,
      quizSectionData: quizSectionData,
    );
  }
}

final fullProgressSectionProvider =
    NotifierProvider<FullProgressSectionProvider, FullProgressSectionData>(
        FullProgressSectionProvider.new);

class FullProgressSectionData {
  final FetchingDataStatus fetchingDataStatus;
  final QuizSectionData quizSectionData;

  FullProgressSectionData({
    required this.fetchingDataStatus,
    required this.quizSectionData,
  });
}

enum FetchingDataStatus {
  fetching,
  notFetching,
}
