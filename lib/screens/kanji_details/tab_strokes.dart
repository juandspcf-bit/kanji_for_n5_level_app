import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/error_connection_tabs.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/strokes_images.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/tab_examples.dart';

class TabStrokes extends ConsumerWidget {
  const TabStrokes({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityData = ref.watch(statusConnectionProvider);
    final kanjiDetailsData = ref.watch(kanjiDetailsProvider);
    final kanjiFromApi = kanjiDetailsData!.kanjiFromApi;
    final statusStorage = kanjiDetailsData.statusStorage;
    return connectivityData == ConnectivityResult.none &&
            kanjiFromApi.statusStorage == StatusStorage.onlyOnline
        ? const ErrorConnectionTabsScreen()
        : StrokesImages(
            kanjiFromApi: kanjiFromApi,
            statusStorage: statusStorage,
          );
  }
}
