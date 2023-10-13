import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KanjiSecctionList extends StatelessWidget {
  const KanjiSecctionList({super.key, required this.sectionModel});

  final SectionModel sectionModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sectionModel.title),
      ),
      body: ListView(
        children: [
          for (final kanjiItem in sectionModel.kanjis)
            KanjiItemWrapper(kanji: kanjiItem)
        ],
      ),
    );
  }
}

class KanjiItemWrapper extends StatefulWidget {
  const KanjiItemWrapper({super.key, required this.kanji});

  final String kanji;
  @override
  State<KanjiItemWrapper> createState() => _KanjiItemState();
}

class _KanjiItemState extends State<KanjiItemWrapper> {
  String? kanjiCharacter;
  String? englishMeaning;
  String? kankiImageLink;
  String? katakanaMeaning;
  String? hiraganaMeaning;

  void getKanjiData() async {
    final kanji = widget.kanji;

    final url = Uri.https(
      "kanjialive-api.p.rapidapi.com",
      "api/public/kanji/$kanji",
    );

    final kanjiInformation = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': '6e8768aba0mshd012d160ea864d6p18a6ccjsn40b2889eeaf9',
        'X-RapidAPI-Host': 'kanjialive-api.p.rapidapi.com'
      },
    );

    final Map<String, dynamic> body = json.decode(kanjiInformation.body);
    final Map<String, dynamic> kanjiInfo = body['kanji'];

    final kanjiCharacterFromAPI = kanjiInfo['character'];

    final Map<String, dynamic> kanjiStrokes = kanjiInfo["strokes"];
    final List<dynamic> kanjiImages = kanjiStrokes["images"];
    final kanjiImageFromAPI = kanjiImages.last as String;

    final Map<String, dynamic> kanjiMeaning = kanjiInfo["meaning"];
    final String englishMeaningFromAPI = kanjiMeaning['english'];

    final Map<String, dynamic> kanjiOnyomi = kanjiInfo["onyomi"];
    final String katakanaMeaningFromAPI = kanjiOnyomi['katakana'];

    final Map<String, dynamic> kanjiKunyomi = kanjiInfo['kunyomi'];
    final String hiraganaMeaningFromAPI = kanjiKunyomi['hiragana'];

    if (body.isNotEmpty && kanjiInformation.statusCode > 400) return;

    if (kanjiCharacterFromAPI == null) return;
    setState(() {
      kanjiCharacter = kanjiCharacterFromAPI;
      kankiImageLink = kanjiImageFromAPI;
      englishMeaning = englishMeaningFromAPI;
      katakanaMeaning = katakanaMeaningFromAPI;
      hiraganaMeaning = hiraganaMeaningFromAPI;
    });
  }

  @override
  void initState() {
    super.initState();
    getKanjiData();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      leading: Stack(alignment: Alignment.center, children: [
        Container(
          color: Colors.white70,
          height: 64,
          width: 128,
        ),
        SvgPicture.network(
          kankiImageLink ?? "",
          height: 64,
          width: 128,
          semanticsLabel: 'A shark?!',
          placeholderBuilder: (BuildContext context) => Container(
              padding: const EdgeInsets.all(30.0),
              child: const CircularProgressIndicator()),
        ),
      ]),
      title: Container(
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
              bottom:
                  BorderSide(style: BorderStyle.solid, color: Colors.white70),
            ),
          ),
          child: Column(
            children: [
              Text(
                englishMeaning ?? "no kanji",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("Onyomi: ${katakanaMeaning ?? '??'}"),
              Text("Kunyomi: ${hiraganaMeaning ?? '??'}"),
            ],
          ),
        ),
      ),
    ); //
  }
}
