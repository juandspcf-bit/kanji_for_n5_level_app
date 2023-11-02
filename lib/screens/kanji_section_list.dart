import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/error_status_after_processing.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/body_list.dart';

import 'package:kanji_for_n5_level_app/screens/quiz_screen/quizz_screen.dart';

class KanjiSectionList extends ConsumerWidget {
  const KanjiSectionList({
    super.key,
  });

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
        (element) => element.statusStorage == StatusStorage.proccessing,
      );

      return true;
    } on StateError {
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiList = ref.watch(kanjiListProvider);
    //final statusProcessingError = ref.watch(errorStatusAfterProcessingStorage);

    final accesToQuiz = !isAnyProcessingData(kanjiList.$1);
    return WillPopScope(
      onWillPop: () {
        try {
          kanjiList.$1.firstWhere(
            (element) => element.statusStorage == StatusStorage.proccessing,
          );

          _scaleDialog(context);

          return Future(() => false);
        } on StateError {
          return Future(() => true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(listSections[kanjiList.$3 - 1].title),
          actions: [
            IconButton(
                onPressed: kanjiList.$2 == 1 && accesToQuiz
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) {
                              return QuizScreen(kanjisModel: kanjiList.$1);
                            },
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.quiz))
          ],
        ),
        body: BodyKanjisList(
          kanjisFromApi: kanjiList.$1,
          statusResponse: kanjiList.$2,
        ),
      ),
    );
  }
}
