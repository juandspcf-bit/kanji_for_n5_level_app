import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/body_list.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/db_dialog_error_message.dart';

import 'package:kanji_for_n5_level_app/screens/quiz_screen/quizz_screen.dart';
import 'package:kanji_for_n5_level_app/screens/status_operations_dialogs.dart';

class KanjiListSectionScreen extends ConsumerWidget
    with DialogErrorInDB, StatusDBStoringDialogs {
  const KanjiListSectionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityData = ref.watch(statusConnectionProvider);
    final mainScreenData = ref.watch(mainScreenProvider);
    if (ref.watch(errorDatabaseStatusProvider)) {
      dbDeletingErrorDialog(context, ref);
    }
    var kanjiListData = ref.watch(kanjiListProvider);
    final statusConnectionData = ref.watch(statusConnectionProvider);
    if (statusConnectionData == ConnectivityResult.none) {
      kanjiListData = ref
          .read(kanjiListProvider.notifier)
          .getOfflineKanjiList(kanjiListData);
    }

    final isAnyProcessingDataFunc =
        ref.read(kanjiListProvider.notifier).isAnyProcessingData;

    final accesToQuiz = !isAnyProcessingDataFunc() &&
        !(statusConnectionData == ConnectivityResult.none);

    return PopScope(
      canPop: !isAnyProcessingDataFunc(),
      onPopInvoked: (didPop) {
        if (isAnyProcessingDataFunc()) {
          statusDBStoringDialog(context);
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(listSections[kanjiListData.section - 1].title),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: statusConnectionData == ConnectivityResult.none
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) {
                              return QuizScreen(
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
      ),
    );
  }
}
