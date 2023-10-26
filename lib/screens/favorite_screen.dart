import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:kanji_for_n5_level_app/API_Files/key_file_api.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kaji_details.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_section_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({
    super.key,
    required this.isFromTabNav,
  });

  final bool isFromTabNav;

  @override
  ConsumerState<FavoriteScreen> createState() => FavoriteScreenState();
}

class FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  List<KanjiFromApi> _kanjisModel = [];
  int statusResponse = 0;
  int dummyFile = 0;

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

  Widget buildScreen(List<String> myFavorites) {
    getKanjis(myFavorites);

    return buildTree(statusResponse, _kanjisModel);
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myFavoritesCachedFromProvider = ref.watch(favoritesCachedProvider);
    return buildScreen(myFavoritesCachedFromProvider.map((e) => e.$3).toList());
  }
}
