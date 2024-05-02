import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';

class ImageMeaningKanjiProvider extends Notifier<ImageMeaningKanjiData> {
  @override
  ImageMeaningKanjiData build() {
    return ImageMeaningKanjiData(
      kanji: '',
      link: '',
      linkHeight: 0,
      linkWidth: 0,
      statusImageMeaningStorage: StatusImageMeaningStorage.online,
    );
  }

  void fetchData(String kanjiCharacter) async {
    try {
      final kanjiData =
          await ref.read(cloudDBServiceProvider).fetchKanjiData(kanjiCharacter);

      state = ImageMeaningKanjiData(
        kanji: kanjiData['kanji'] as String,
        link: kanjiData['link'] as String,
        linkHeight: kanjiData['linkHeight'],
        linkWidth: kanjiData['linkWidth'],
        statusImageMeaningStorage: StatusImageMeaningStorage.online,
      );
    } catch (e) {
      state = ImageMeaningKanjiData(
          kanji: '',
          link: '',
          linkHeight: 0,
          linkWidth: 0,
          statusImageMeaningStorage: StatusImageMeaningStorage.online);
    }
  }

  void clearState() {
    state = ImageMeaningKanjiData(
      kanji: '',
      link: '',
      linkHeight: 0,
      linkWidth: 0,
      statusImageMeaningStorage: StatusImageMeaningStorage.online,
    );
  }
}

final imageMeaningKanjiProvider =
    NotifierProvider<ImageMeaningKanjiProvider, ImageMeaningKanjiData>(
        ImageMeaningKanjiProvider.new);

class ImageMeaningKanjiData {
  final String kanji;
  final String link;
  final int linkHeight;
  final int linkWidth;
  final StatusImageMeaningStorage statusImageMeaningStorage;

  ImageMeaningKanjiData({
    required this.kanji,
    required this.link,
    required this.linkHeight,
    required this.linkWidth,
    required this.statusImageMeaningStorage,
  });
}

enum StatusImageMeaningStorage {
  online,
  stored,
}
