import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_firebase_impl/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/body_list.dart';
import 'package:kanji_for_n5_level_app/screens/common_widgets/my_dialogs.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';

import 'package:kanji_for_n5_level_app/screens/quiz_screen/quizz_screen.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/welcome_screen/last_score_provider.dart';
import 'package:kanji_for_n5_level_app/screens/status_operations_dialogs.dart';

class KanjiForSectionScreen extends ConsumerWidget
    with MyDialogs, StatusDBStoringDialogs {
  const KanjiForSectionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityData = ref.watch(statusConnectionProvider);
    final mainScreenData = ref.watch(mainScreenProvider);
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
                            .read(lastScoreProvider.notifier)
                            .getKanjiQuizLastScore(
                              ref.read(sectionProvider),
                              authService.user ?? '',
                            );
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
