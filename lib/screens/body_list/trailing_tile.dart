import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/selection_navigation_bar_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class TrailingTile extends ConsumerWidget {
  const TrailingTile({
    super.key,
    required this.kanjiFromApi,
  });

  final KanjiFromApi kanjiFromApi;

  Widget selectWidgetStatus(KanjiFromApi kanjiFromApi, BuildContext context) {
    if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
      return Icon(
        Icons.download_for_offline,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        size: 50,
      );
    } else if (kanjiFromApi.statusStorage == StatusStorage.stored) {
      return Icon(
        Icons.storage,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        size: 50,
      );
    } else if (kanjiFromApi.statusStorage == StatusStorage.proccessingStoring ||
        kanjiFromApi.statusStorage == StatusStorage.proccessingDeleting) {
      return const CircularProgressIndicator();
    } else {
      return Icon(
        Icons.question_mark_rounded,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        size: 50,
      );
    }
  }

  void showSnackBarQuizz(BuildContext context, String message, int duration) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: duration),
          content: Text(message),
        ),
      );
    }
  }

  int countActiveDownloads(List<KanjiFromApi> kanjiList) {
    return kanjiList
        .where(
            (kanji) => kanji.statusStorage == StatusStorage.proccessingStoring)
        .toList()
        .length;
  }

  bool isMoreOfTheAllowedDownloads(
      BuildContext context, List<KanjiFromApi> kanjiList) {
    int countActivesDownloads = countActiveDownloads(kanjiList);
    return countActivesDownloads >= 3;
  }

  void setToProccesingStatus(
      StatusStorage proccessingStoring, int selection, WidgetRef ref) {
    if (selection == 1) {
      ref.read(favoritesListProvider.notifier).updateKanji(
            updateStatusKanji(proccessingStoring, false, kanjiFromApi),
          );
    } else {
      ref.read(kanjiListProvider.notifier).updateKanji(
            updateStatusKanji(proccessingStoring, false, kanjiFromApi),
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (!kanjiFromApi.accessToKanjiItemsButtons) return;

        final resultStatus = ref.read(statusConnectionProvider);
        if (ConnectivityResult.none == resultStatus) {
          showSnackBarQuizz(
              context, 'you shoul be connected to perform this acction', 3);
          return;
        }

        final selection = ref.read(selectionNavigationBarScreen);
        if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
          setToProccesingStatus(
              StatusStorage.proccessingStoring, selection, ref);

          if (selection == 0) {
            ref
                .read(kanjiListProvider.notifier)
                .insertKanjiToStorageComputeVersion(kanjiFromApi, selection);
          } else {
            ref
                .read(favoritesListProvider.notifier)
                .insertKanjiToStorageComputeVersion(kanjiFromApi, selection);
          }

          /* ref
              .read(kanjiListProvider.notifier)
              .insertKanjiToStorageComputeVersion(kanjiFromApi, selection); */
        } else if (kanjiFromApi.statusStorage == StatusStorage.stored) {
          setToProccesingStatus(
              StatusStorage.proccessingDeleting, selection, ref);
          ref
              .read(kanjiListProvider.notifier)
              .deleteKanjiFromStorageComputeVersion(kanjiFromApi, selection);
        }
      },
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: selectWidgetStatus(kanjiFromApi, context),
      ),
    );
  }
}

KanjiFromApi updateStatusKanji(
  StatusStorage statusStorage,
  bool accessToKanjiItemsButtons,
  KanjiFromApi kanjiFromApi,
) {
  return KanjiFromApi(
      kanjiCharacter: kanjiFromApi.kanjiCharacter,
      englishMeaning: kanjiFromApi.englishMeaning,
      kanjiImageLink: kanjiFromApi.kanjiImageLink,
      katakanaMeaning: kanjiFromApi.katakanaMeaning,
      hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
      videoLink: kanjiFromApi.videoLink,
      section: kanjiFromApi.section,
      statusStorage: statusStorage,
      accessToKanjiItemsButtons: accessToKanjiItemsButtons,
      example: kanjiFromApi.example,
      strokes: kanjiFromApi.strokes);
}
