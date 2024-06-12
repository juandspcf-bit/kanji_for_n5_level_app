import 'package:flutter/foundation.dart';

import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class KanjiFromApi {
  final String kanjiCharacter;
  final String englishMeaning;
  final String kanjiImageLink;
  final String katakanaRomaji;
  final String katakanaMeaning;
  final String hiraganaRomaji;
  final String hiraganaMeaning;
  final String videoLink;
  final int section;
  final StatusStorage statusStorage;
  final bool accessToKanjiItemsButtons;
  final List<Example> example;
  final Strokes strokes;

  KanjiFromApi(
      {required this.kanjiCharacter,
      required this.englishMeaning,
      required this.kanjiImageLink,
      required this.katakanaRomaji,
      required this.katakanaMeaning,
      required this.hiraganaRomaji,
      required this.hiraganaMeaning,
      required this.videoLink,
      required this.section,
      required this.statusStorage,
      required this.accessToKanjiItemsButtons,
      required this.example,
      required this.strokes});

  KanjiFromApi copyWith({
    String? kanjiCharacter,
    String? englishMeaning,
    String? kanjiImageLink,
    String? katakanaRomaji,
    String? katakanaMeaning,
    String? hiraganaRomaji,
    String? hiraganaMeaning,
    String? videoLink,
    int? section,
    StatusStorage? statusStorage,
    bool? accessToKanjiItemsButtons,
    List<Example>? example,
    Strokes? strokes,
  }) {
    return KanjiFromApi(
      kanjiCharacter: kanjiCharacter ?? this.kanjiCharacter,
      englishMeaning: englishMeaning ?? this.englishMeaning,
      kanjiImageLink: kanjiImageLink ?? this.kanjiImageLink,
      katakanaRomaji: katakanaRomaji ?? this.katakanaRomaji,
      katakanaMeaning: katakanaMeaning ?? this.katakanaMeaning,
      hiraganaRomaji: hiraganaRomaji ?? this.hiraganaRomaji,
      hiraganaMeaning: hiraganaMeaning ?? this.hiraganaMeaning,
      videoLink: videoLink ?? this.videoLink,
      section: section ?? this.section,
      statusStorage: statusStorage ?? this.statusStorage,
      accessToKanjiItemsButtons:
          accessToKanjiItemsButtons ?? this.accessToKanjiItemsButtons,
      example: example ?? this.example,
      strokes: strokes ?? this.strokes,
    );
  }

  @override
  String toString() {
    return 'KanjiFromApi(kanjiCharacter: $kanjiCharacter, englishMeaning: $englishMeaning, kanjiImageLink: $kanjiImageLink, katakanaRomaji: $katakanaRomaji, katakanaMeaning: $katakanaMeaning, hiraganaRomaji: $hiraganaRomaji, hiraganaMeaning: $hiraganaMeaning, videoLink: $videoLink, section: $section, statusStorage: $statusStorage, accessToKanjiItemsButtons: $accessToKanjiItemsButtons, example: $example, strokes: $strokes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KanjiFromApi &&
        other.kanjiCharacter == kanjiCharacter &&
        other.englishMeaning == englishMeaning &&
        other.kanjiImageLink == kanjiImageLink &&
        other.katakanaRomaji == katakanaRomaji &&
        other.katakanaMeaning == katakanaMeaning &&
        other.hiraganaRomaji == hiraganaRomaji &&
        other.hiraganaMeaning == hiraganaMeaning &&
        other.videoLink == videoLink &&
        other.section == section &&
        other.statusStorage == statusStorage &&
        other.accessToKanjiItemsButtons == accessToKanjiItemsButtons &&
        listEquals(other.example, example) &&
        other.strokes == strokes;
  }

  @override
  int get hashCode {
    return kanjiCharacter.hashCode ^
        englishMeaning.hashCode ^
        kanjiImageLink.hashCode ^
        katakanaRomaji.hashCode ^
        katakanaMeaning.hashCode ^
        hiraganaRomaji.hashCode ^
        hiraganaMeaning.hashCode ^
        videoLink.hashCode ^
        section.hashCode ^
        statusStorage.hashCode ^
        accessToKanjiItemsButtons.hashCode ^
        example.hashCode ^
        strokes.hashCode;
  }
}

class Example {
  final String japanese;
  final Meaning meaning;
  final AudioExamples audio;

  Example({
    required this.japanese,
    required this.meaning,
    required this.audio,
  });
}

class Meaning {
  final String english;
  Meaning({required this.english});
}

class AudioExamples {
  final String mp3;

  AudioExamples({required this.mp3});
}

class ImageDetailsLink {
  final String kanji;
  final String link;
  final int linkHeight;
  final int linkWidth;

  ImageDetailsLink({
    required this.kanji,
    required this.link,
    required this.linkHeight,
    required this.linkWidth,
  });
}

class Strokes {
  final int count;
  final List<String> images;

  Strokes({
    required this.count,
    required this.images,
  });
}

KanjiFromApi buildKanjiInfoFromApi(Map<String, dynamic> body, int section) {
  final Map<String, dynamic> kanji = body['kanji'];

  final String kanjiCharacterFromAPI = kanji['character'];

  final Map<String, dynamic> kanjiMeaning = kanji["meaning"];
  final String englishMeaningFromAPI = kanjiMeaning['english'];

  final Map<String, dynamic> kanjiStrokes = kanji["strokes"];

  final List<dynamic> kanjiImagesFromApis = kanjiStrokes["images"];
  final kanjiImages = kanjiImagesFromApis.map((e) => e as String).toList();

  final String kanjiImageFromAPI = kanjiImages.last;
  final strokesInfo = Strokes(
    count: kanjiStrokes['count'],
    images: kanjiImages,
  );

  final Map<String, dynamic> kanjiOnyomi = kanji["onyomi"];
  final String katakanaRomajiMeaningFromAPI = kanjiOnyomi['romaji'];
  final String katakanaMeaningFromAPI = kanjiOnyomi['katakana'];

  final Map<String, dynamic> kanjiKunyomi = kanji['kunyomi'];
  final String hiraganaRomajiMeaningFromAPI = kanjiKunyomi['romaji'];
  final String hiraganaMeaningFromAPI = kanjiKunyomi['hiragana'];

  final Map<String, dynamic> kanjiVideo = kanji['video'];
  final String videoLinkFromAPI = kanjiVideo['mp4'];

  final List<dynamic> examplesFromAPI = body['examples'];

  List<Example> examples = examplesFromAPI.map((e) {
    //
    final String japanese = e["japanese"];
    final Map<String, dynamic> meaningMap = e['meaning'];
    final meaning = Meaning(english: meaningMap['english'] as String);
    final Map<String, dynamic> audioMap = e['audio'];
    final audio = AudioExamples(mp3: audioMap['mp3']);

    return Example(
      japanese: japanese,
      meaning: meaning,
      audio: audio,
    );
  }).toList();

  final kanjiFromApi = KanjiFromApi(
      kanjiCharacter: kanjiCharacterFromAPI,
      englishMeaning: englishMeaningFromAPI,
      kanjiImageLink: kanjiImageFromAPI,
      katakanaRomaji: katakanaRomajiMeaningFromAPI,
      katakanaMeaning: katakanaMeaningFromAPI,
      hiraganaRomaji: hiraganaRomajiMeaningFromAPI,
      hiraganaMeaning: hiraganaMeaningFromAPI,
      section: section,
      videoLink: videoLinkFromAPI,
      statusStorage: StatusStorage.onlyOnline,
      accessToKanjiItemsButtons: true,
      example: examples,
      strokes: strokesInfo);

  return kanjiFromApi;
}
