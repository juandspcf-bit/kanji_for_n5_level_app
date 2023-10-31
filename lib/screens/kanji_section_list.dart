import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
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
/*   List<KanjiFromApi> _kanjisFromApi = [];
  int statusResponse = 0;

  void onSuccesRequest(List<KanjiFromApi> kanjisFromApi) {
    setState(() {
      _kanjisFromApi = kanjisFromApi;
      statusResponse = 1;
    });
  }

  void onErrorRequest() {
    setState(() {
      statusResponse = 2;
    });
  } */

  @override
  void initState() {
    super.initState();
/*     ref.read(kanjiListProvider.notifier).clearKanjiList();
    final storedKanjis =
        ref.read(statusStorageProvider.notifier).getStoresItems();
    ref
        .read(kanjiListProvider.notifier)
        .setKanjiList(storedKanjis, widget.sectionModel.kanjis); */
/*     RequestApi.getKanjis(
      storedKanjis,
      widget.sectionModel.kanjis,
      onSuccesRequest,
      onErrorRequest,
    ); */
  }

  @override
  Widget build(BuildContext context) {
    final kanjiList = ref.watch(kanjiListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sectionModel.title),
        actions: [
          IconButton(
              onPressed: kanjiList.$2 == 1
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
