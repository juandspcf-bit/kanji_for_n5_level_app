import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';

class FullProgressSectionProvider extends Notifier<FullProgressSectionData> {
  @override
  FullProgressSectionData build() {
    return FullProgressSectionData(
        fetchingDataStatus: FetchingDataStatus.notFetching);
  }

  void fetchData(int section) async {
    state = FullProgressSectionData(
        fetchingDataStatus: FetchingDataStatus.fetching);

    await ref.read(localDBServiceProvider).getQuizSectionDataFromDB(
          ref.read(authServiceProvider).userUuid ?? '',
          section,
        );

    state = FullProgressSectionData(
        fetchingDataStatus: FetchingDataStatus.notFetching);
  }
}

final fullProgressSectionProvider =
    NotifierProvider<FullProgressSectionProvider, FullProgressSectionData>(
        FullProgressSectionProvider.new);

class FullProgressSectionData {
  final FetchingDataStatus fetchingDataStatus;

  FullProgressSectionData({
    required this.fetchingDataStatus,
  });
}

enum FetchingDataStatus {
  fetching,
  notFetching,
}
