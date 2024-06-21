import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/models/quiz_section_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_section_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "full_progress_section_provider.g.dart";

@Riverpod(keepAlive: true)
class FullProgressSection extends _$FullProgressSection {
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
/* 
final fullProgressSectionProvider =
    NotifierProvider<FullProgressSection, FullProgressSectionData>(
        FullProgressSection.new); */

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
