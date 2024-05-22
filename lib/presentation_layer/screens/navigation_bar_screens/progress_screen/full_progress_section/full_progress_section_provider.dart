import 'package:flutter_riverpod/flutter_riverpod.dart';

class FullProgressSectionProvider extends Notifier<FullProgressSectionData> {
  @override
  FullProgressSectionData build() {
    return FullProgressSectionData(
        fetchingDataStatus: FetchingDataStatus.notFetching);
  }

  void fetchData() {}
}

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
