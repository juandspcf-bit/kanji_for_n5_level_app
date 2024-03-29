import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_list_screen/quiz_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/body_list.dart';
import 'package:kanji_for_n5_level_app/screens/common_widgets/my_dialogs.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';

import 'package:kanji_for_n5_level_app/screens/quiz_kanji_list_screen/kanji_quiz_screen.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_list_screen/welcome_screen/last_score_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/status_operations_dialogs.dart';

class KanjiForSectionScreen extends ConsumerWidget
    with MyDialogs, StatusDBStoringDialogs {
  const KanjiForSectionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(errorDatabaseStatusProvider)) {
      errorDialog(
        context,
        () {
          ref
              .read(errorDatabaseStatusProvider.notifier)
              .setDeletingError(false);
        },
        'An issue happened when deleting this item, please go back to the section'
        ' list and access the content again to see the updated content.',
      );
    }

    final connectivityData = ref.watch(statusConnectionProvider);
    final mainScreenData = ref.watch(mainScreenProvider);
    var kanjiListData = ref.watch(kanjiListProvider);

    if (connectivityData == ConnectivityResult.none) {
      kanjiListData = ref
          .read(kanjiListProvider.notifier)
          .getOfflineKanjiList(kanjiListData);
    }

    final isAnyProcessingDataFunc =
        ref.read(kanjiListProvider.notifier).isAnyProcessingData;

    final accesToQuiz = !isAnyProcessingDataFunc() &&
        !(connectivityData == ConnectivityResult.none);

    ref.listen<KanjiListData>(kanjiListProvider, (previuos, current) {
      if (current.errorDownload.status) {
        ScaffoldMessenger.of(context).clearSnackBars();
        var snackBar = SnackBar(
          content: Text(
              'error downloading kanji ${current.errorDownload.kanjiCharacter}'),
          duration: const Duration(seconds: 3),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        ref.read(kanjiListProvider.notifier).setErrorDownload(
              ErrorDownload(
                kanjiCharacter: '',
                status: false,
              ),
            );
      }

      if (current.errorDeleting.status) {
        ScaffoldMessenger.of(context).clearSnackBars();
        var snackBar = SnackBar(
          content: Text(
              'error removing stored kanji ${current.errorDeleting.kanjiCharacter}'),
          duration: const Duration(seconds: 3),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        ref.read(kanjiListProvider.notifier).setErrorDelete(
              ErrorDeleting(
                kanjiCharacter: '',
                status: false,
              ),
            );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(listSections[kanjiListData.section - 1].title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: connectivityData == ConnectivityResult.none
                ? const Icon(Icons.cloud_off)
                : const Icon(Icons.cloud_done_rounded),
          ),
          IconButton(
              onPressed: kanjiListData.status == 1 && accesToQuiz
                  ? () {
                      ref
                          .read(quizDataValuesProvider.notifier)
                          .initTheStateBeforeAccessingQuizScreen(
                              kanjiListData.kanjiList.length,
                              kanjiListData.kanjiList);
                      ref
                          .read(lastScoreKanjiQuizProvider.notifier)
                          .getKanjiQuizLastScore(
                            ref.read(sectionProvider),
                            authService.user ?? '',
                          );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) {
                            return KanjiQuizScreen(
                                kanjisFromApi: kanjiListData.kanjiList);
                          },
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.quiz))
        ],
      ),
      body: BodyKanjisList(
        kanjisFromApi: kanjiListData.kanjiList,
        statusResponse: kanjiListData.status,
        connectivityData: connectivityData,
        mainScreenData: mainScreenData,
      ),
    );
  }
}
