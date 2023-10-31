import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';
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
  List<KanjiFromApi> _kanjisFromApi = [];
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
  }

  @override
  void initState() {
    super.initState();
    final storedKanjis =
        ref.read(statusStorageProvider.notifier).getStoresItems();
    RequestApi.getKanjis(
      storedKanjis,
      widget.sectionModel.kanjis,
      onSuccesRequest,
      onErrorRequest,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                            return QuizScreen(kanjisModel: _kanjisFromApi);
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
        kanjisFromApi: _kanjisFromApi,
      ),
    );
  }
}
