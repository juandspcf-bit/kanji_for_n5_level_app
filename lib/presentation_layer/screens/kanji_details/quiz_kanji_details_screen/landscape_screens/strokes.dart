import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/locazition.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_connection_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/strokes_images.dart';

class StrokesLandScape extends ConsumerWidget {
  const StrokesLandScape({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityData = ref.watch(statusConnectionProvider);
    final kanjiDetailsData = ref.watch(kanjiDetailsProvider);
    final kanjiFromApi = kanjiDetailsData!.kanjiFromApi;
    final statusStorage = kanjiDetailsData.statusStorage;
    return connectivityData == ConnectionStatus.noConnected &&
            kanjiFromApi.statusStorage == StatusStorage.onlyOnline
        ? const ErrorConnectionDetailsScreen()
        : SafeArea(
            child: StrokesImages(
              kanjiFromApi: kanjiFromApi,
              statusStorage: statusStorage,
            ),
          );
  }
}
