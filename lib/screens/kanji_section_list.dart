import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:kanji_for_n5_level_app/API_Files/key_file_api.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:http/http.dart' as http;
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_providers.dart';
import 'dart:convert';

import 'package:kanji_for_n5_level_app/screens/kaji_details.dart';

class KanjiList extends StatefulWidget {
  const KanjiList({
    super.key,
    required this.sectionModel,
    required this.isFromTabNav,
  });
  final bool isFromTabNav;

  final SectionModel sectionModel;

  @override
  State<KanjiList> createState() => _KanjiListState();
}

class _KanjiListState extends State<KanjiList> {
  List<KanjiFromApi> _kanjisModel = [];
  int statusResponse = 0;

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
    ).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
  }

  void refreshData() {
    if (!widget.isFromTabNav) return;
    setState(() {
      statusResponse = 0;
    });
    getKanjis(myFavoritesCached.map((e) => e.$3).toList());
  }

  void getKanjis(List<String> kanjis) {
    FutureGroup<Response> group = FutureGroup<Response>();

    for (final kanji in kanjis) {
      group.add(getKanjiData(kanji));
    }

    group.close();

    List<Map<String, dynamic>> bodies = [];
    List<KanjiFromApi> kanjisFromApi = [];
    group.future.then((List<Response> kanjiInformationList) {
      for (final kanjiInformation in kanjiInformationList) {
        bodies.add(json.decode(kanjiInformation.body));
      }

      for (final body in bodies) {
        kanjisFromApi.add(builKanjiInfoFromApi(body));
      }

      setState(() {
        _kanjisModel = kanjisFromApi;
        statusResponse = 1;
      });
    }).catchError((onError) {
      setState(() {
        statusResponse = 2;
      });
    });
  }

  Future<Response> getKanjiData(String kanji) async {
    final url = Uri.https(
      "kanjialive-api.p.rapidapi.com",
      "api/public/kanji/$kanji",
    );

    return http.get(
      url,
      headers: {
        'X-RapidAPI-Key': xRapidAPIKey,
        'X-RapidAPI-Host': 'kanjialive-api.p.rapidapi.com'
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getKanjis(widget.sectionModel.kanjis);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isFromTabNav
        ? Scaffold(body: buildTree(statusResponse, _kanjisModel))
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.sectionModel.title),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.quiz))
              ],
            ),
            body: buildTree(statusResponse, _kanjisModel));
  }

  Widget buildTree(int statusResponse, List<KanjiFromApi> kanjisModel) {
    if (statusResponse == 0) {
      return const Center(child: CircularProgressIndicator());
    } else if (statusResponse == 1) {
      return ListView.builder(
          itemCount: kanjisModel.length,
          itemBuilder: (ctx, index) {
            return KanjiItem(
              key: ValueKey(kanjisModel[index].kanjiCharacter),
              kanjiFromApi: kanjisModel[index],
              navigateToKanjiDetails: navigateToKanjiDetails,
            ); //Text('${kanjisModel[index].kanjiCharacter} : ${kanjisModel[index].englishMeaning}');
          });
    } else {
      return const Text('An error has occurr');
    }
  }
}

class KanjiItem extends StatelessWidget {
  const KanjiItem({
    super.key,
    required this.kanjiFromApi,
    required this.navigateToKanjiDetails,
  });

  final KanjiFromApi kanjiFromApi;
  final void Function(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) navigateToKanjiDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToKanjiDetails(context, kanjiFromApi);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: SvgPicture.network(
                kanjiFromApi.kanjiImageLink,
                height: 80,
                width: 80,
                semanticsLabel: kanjiFromApi.kanjiCharacter,
                placeholderBuilder: (BuildContext context) => Container(
                    color: Colors.transparent,
                    height: 40,
                    width: 40,
                    child: const CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(179, 5, 16, 51),
                    )),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(180, 250, 8, 8),
                    Color.fromARGB(180, 192, 20, 20),
                    Color.fromARGB(70, 121, 21, 21)
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          style: BorderStyle.solid, color: Colors.white70),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        kanjiFromApi.englishMeaning,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Kunyomi: ${kanjiFromApi.hiraganaMeaning}"),
                      Text("Onyomi: ${kanjiFromApi.katakanaMeaning}"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

KanjiFromApi builKanjiInfoFromApi(Map<String, dynamic> body) {
  final Map<String, dynamic> kanjiInfo = body['kanji'];

  final String kanjiCharacterFromAPI = kanjiInfo['character'];

  final Map<String, dynamic> kanjiStrokes = kanjiInfo["strokes"];
  //final List<dynamic> kanjiTimingsFromApis = kanjiStrokes["timings"];
  //final kanjiTimings = kanjiTimingsFromApis.map((e) => e as int).toList();

  final List<dynamic> kanjiImagesFromApis = kanjiStrokes["images"];
  final kanjiImages = kanjiImagesFromApis.map((e) => e as String).toList();

  final String kanjiImageFromAPI = kanjiImages.last;
  final strokesInfo = Strokes(
    count: kanjiStrokes['count'],
    images: kanjiImages,
  );

  final Map<String, dynamic> kanjiMeaning = kanjiInfo["meaning"];
  final String englishMeaningFromAPI = kanjiMeaning['english'];

  final Map<String, dynamic> kanjiOnyomi = kanjiInfo["onyomi"];
  final String katakanaMeaningFromAPI = kanjiOnyomi['katakana'];

  final Map<String, dynamic> kanjiKunyomi = kanjiInfo['kunyomi'];
  final String hiraganaMeaningFromAPI = kanjiKunyomi['hiragana'];

  final Map<String, dynamic> kanjiVideo = kanjiInfo['video'];
  final String videoLinkFromAPI = kanjiVideo['mp4'];

  final List<dynamic> examplesFromAPI = body['examples'];

  List<Examples> examples = examplesFromAPI.map((e) {
    //
    final String japanese = e["japanese"];
    final Map<String, dynamic> meaningMap = e['meaning'];
    final meaning = Meaning(english: meaningMap['english'] as String);
    final Map<String, dynamic> audioMap = e['audio'];
    final audio = AudioExamples(
        opus: audioMap['opus'],
        aac: audioMap['aac'],
        ogg: audioMap['ogg'],
        mp3: audioMap['mp3']);

    return Examples(
      japanese: japanese,
      meaning: meaning,
      audio: audio,
    );
  }).toList();

  final kanjiFromApi = KanjiFromApi(
      kanjiCharacter: kanjiCharacterFromAPI,
      englishMeaning: englishMeaningFromAPI,
      kanjiImageLink: kanjiImageFromAPI,
      katakanaMeaning: katakanaMeaningFromAPI,
      hiraganaMeaning: hiraganaMeaningFromAPI,
      videoLink: videoLinkFromAPI,
      example: examples,
      strokes: strokesInfo);

  return kanjiFromApi;
}
