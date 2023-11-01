import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/access_to_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/body_list.dart';

import 'package:kanji_for_n5_level_app/screens/quiz_screen/quizz_screen.dart';

class KanjiList extends ConsumerStatefulWidget {
  const KanjiList({
    super.key,
    required this.sectionModel,
  });

  final SectionModel sectionModel;

  @override
  ConsumerState<KanjiList> createState() => _KanjiListState();
}

class _KanjiListState extends ConsumerState<KanjiList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final kanjiList = ref.watch(kanjiListProvider);
    final accesToQuiz = ref.watch(accesToQuizProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sectionModel.title),
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
    );
  }
}
