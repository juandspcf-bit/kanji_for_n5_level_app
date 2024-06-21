import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/models/quiz_section_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "full_progress_section_provider.g.dart";

@riverpod
Future<FullProgressSectionData> fullProgressSection(FullProgressSectionRef ref,
    {required int section}) async {
  final quizSectionData =
      await ref.read(localDBServiceProvider).getQuizSectionDataFromDB(
            ref.read(authServiceProvider).userUuid ?? '',
            section,
          );

  return FullProgressSectionData(
    fetchingDataStatus: FetchingDataStatus.notFetching,
    quizSectionData: quizSectionData,
  );
}

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
