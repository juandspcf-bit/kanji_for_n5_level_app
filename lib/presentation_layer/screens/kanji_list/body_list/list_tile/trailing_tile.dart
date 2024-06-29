import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/section_model.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/queue_download_delete_provider.dart';
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
      return SvgPicture.asset(
        height: 60,
        width: 60,
        "assets/icons/download.svg",
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        placeholderBuilder: (BuildContext context) => Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          color: Colors.transparent,
          height: 80,
          width: 80,
          child: const CircularProgressIndicator(
            backgroundColor: Color.fromARGB(179, 5, 16, 51),
          ),
        ),
      );
    } else if (kanjiFromApi.statusStorage == StatusStorage.stored) {
      return Icon(
        Icons.storage_outlined,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        size: 50,
      );
    } else if (kanjiFromApi.statusStorage == StatusStorage.processingStoring ||
        kanjiFromApi.statusStorage == StatusStorage.processingDeleting) {
      return const CircularProgressIndicator();
    } else {
      return Icon(
        Icons.question_mark_outlined,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        size: 50,
      );
    }
  }

  void showSnackBarQuiz(
    BuildContext context,
    String message,
    WidgetRef ref,
  ) {
    if (context.mounted) {
      ref.read(toastServiceProvider).dismiss(context);
      ref.read(toastServiceProvider).showShortMessage(context, message);
    }
  }

  int countActiveDownloads(List<KanjiFromApi> kanjiList) {
    return kanjiList
        .where(
            (kanji) => kanji.statusStorage == StatusStorage.processingStoring)
        .toList()
        .length;
  }

  bool isMoreOfTheAllowedDownloads(
      BuildContext context, List<KanjiFromApi> kanjiList) {
    int countActivesDownloads = countActiveDownloads(kanjiList);
    return countActivesDownloads >= 3;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        if (!kanjiFromApi.accessToKanjiItemsButtons) return;

        final resultStatus = ref.read(statusConnectionProvider);
        if (ConnectionStatus.noConnected == resultStatus) {
          showSnackBarQuiz(
            context,
            'you should be connected to perform this action',
            ref,
          );
          return;
        }

        if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
          ref
              .read(queueDownloadDeleteProvider.notifier)
              .insertKanjiToStorage(kanjiFromApi);
        } else if (kanjiFromApi.statusStorage == StatusStorage.stored) {
          ref
              .read(queueDownloadDeleteProvider.notifier)
              .deleteKanjiFromStorage(kanjiFromApi);
        }
      },
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: selectWidgetStatus(kanjiFromApi, context),
      ),
    );
  }

  KanjiFromApi setCorrectSection(KanjiFromApi kanjiFromApi) {
    var correctKanjiFromApi = kanjiFromApi;
    for (var key in sectionsKanjis.keys) {
      int index = sectionsKanjis[key]!
          .indexWhere((element) => element == kanjiFromApi.kanjiCharacter);
      if (index != -1) {
        int? section = int.tryParse(key.substring(7));
        correctKanjiFromApi = kanjiFromApi.copyWith(
          section: section ?? 10,
        );
        break;
      }
    }
    return correctKanjiFromApi;
  }
}
