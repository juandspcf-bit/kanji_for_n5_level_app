import 'package:flutter/material.dart';
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
            KanjiItem(kanji: kanjiItem)
        ],
      ),
    );
  }
}

class KanjiItem extends StatefulWidget {
  const KanjiItem({super.key, required this.kanji});

  final String kanji;
  @override
  State<KanjiItem> createState() => _KanjiItemState();
}

class _KanjiItemState extends State<KanjiItem> {
  String? kanjiCharacter;

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
    final Map<String, dynamic> radical = body['radical'];
    final kanjiCharacterFromAPI = radical["character"];

    if (kanjiCharacterFromAPI == null) return;
    setState(() {
      kanjiCharacter = kanjiCharacterFromAPI;
    });
  }

  @override
  void initState() {
    super.initState();
    getKanjiData();
  }

  @override
  Widget build(BuildContext context) {
    return Text(kanjiCharacter ?? "no kanji");
  }
}
