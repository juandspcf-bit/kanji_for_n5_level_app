import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_connection_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/strokes_images.dart';

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
        ? const ErrorConnectionScreen(
            message:
                'No internet connection, you will be able to acces the info when the connection is restored',
          )
        : StrokesImages(
            kanjiFromApi: kanjiFromApi,
            statusStorage: statusStorage,
          );
  }
}
