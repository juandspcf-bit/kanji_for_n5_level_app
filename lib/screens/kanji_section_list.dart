import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/body_list.dart';

import 'package:kanji_for_n5_level_app/screens/quiz_screen/quizz_screen.dart';

class KanjiSectionList extends ConsumerStatefulWidget {
  const KanjiSectionList({
    super.key,
  });

  @override
  ConsumerState<KanjiSectionList> createState() => _KanjiSectionListState();
}

class _KanjiSectionListState extends ConsumerState<KanjiSectionList> {
  Widget _dialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Please wait!!"),
      content: const Text('Please wait until all the operations are completed'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

  void _scaleDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  bool isAnyProcessingData(List<KanjiFromApi> list) {
    try {
      list.firstWhere(
        (element) =>
            element.statusStorage == StatusStorage.proccessingStoring ||
            element.statusStorage == StatusStorage.proccessingDeleting,
      );

      return true;
    } on StateError {
      return false;
    }
  }

  void showSnackBarQuizz(String message, int duration) {
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: duration),
          content: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var kanjiList =
        KanjiListData(kanjiList: <KanjiFromApi>[], status: 0, section: 1);
    final resultStatus = ref.watch(statusConnectionProvider);
    if (resultStatus == ConnectivityResult.none) {
      final kanjiListFromProvider = ref.read(kanjiListProvider);
      final storedKanjis = ref.read(storedKanjisProvider);

      if (storedKanjis[kanjiListFromProvider.section] != null &&
          storedKanjis[kanjiListFromProvider.section]!.isNotEmpty) {
        kanjiList = KanjiListData(
            kanjiList: storedKanjis[kanjiListFromProvider.section]!,
            status: 1,
            section: kanjiListFromProvider.section);
      } else {
        kanjiList = KanjiListData(
            kanjiList: <KanjiFromApi>[],
            status: 1,
            section: kanjiListFromProvider.section);
      }
    } else {
      kanjiList = ref.watch(kanjiListProvider);
    }

    final accesToQuiz = !isAnyProcessingData(kanjiList.kanjiList) &&
        !(resultStatus == ConnectivityResult.none);
    return WillPopScope(
      onWillPop: () {
        try {
          kanjiList.kanjiList.firstWhere(
            (element) =>
                element.statusStorage == StatusStorage.proccessingStoring ||
                element.statusStorage == StatusStorage.proccessingDeleting,
          );

          _scaleDialog(context);

          return Future(() => false);
        } on StateError {
          return Future(() => true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(listSections[kanjiList.section - 1].title),
          actions: [
            IconButton(
                onPressed: kanjiList.status == 1 && accesToQuiz
                    ? () {
                        ref
                            .read(quizDataValuesProvider.notifier)
                            .initTheStateBeforeAccessingQuizScreen(
                                kanjiList.kanjiList.length,
                                kanjiList.kanjiList);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) {
                              return QuizScreen(
                                  kanjisFromApi: kanjiList.kanjiList);
                            },
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.quiz))
          ],
        ),
        body: BodyKanjisList(
          kanjisFromApi: kanjiList.kanjiList,
          statusResponse: kanjiList.status,
        ),
      ),
    );
  }
}
