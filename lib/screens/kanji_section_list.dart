import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/body_list.dart';

import 'package:kanji_for_n5_level_app/screens/kaji_details.dart';
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
  List<KanjiFromApi> _kanjisModel = [];
  int statusResponse = 0;

  void onSuccesRequest(List<KanjiFromApi> kanjisFromApi) {
    setState(() {
      _kanjisModel = kanjisFromApi;
      statusResponse = 1;
    });
  }

  void onErrorRequest() {
    setState(() {
      statusResponse = 2;
    });
  }

  void navigateToKanjiDetails(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) {
    if (kanjiFromApi == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) {
        return KanjiDetails(
          kanjiFromApi: kanjiFromApi,
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    RequestApi.getKanjis(
        widget.sectionModel.kanjis, onSuccesRequest, onErrorRequest);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(statusStorageProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sectionModel.title),
        actions: [
          IconButton(
              onPressed: statusResponse == 1
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) {
                            return QuizScreen(kanjisModel: _kanjisModel);
                          },
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.quiz))
        ],
      ),
      body: BodyKanjisList(
        statusResponse: statusResponse,
        kanjisFromApi: _kanjisModel,
        navigateToKanjiDetails: navigateToKanjiDetails,
      ),
    );
  }
}
