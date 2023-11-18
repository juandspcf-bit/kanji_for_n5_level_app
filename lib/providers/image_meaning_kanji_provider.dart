import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class ImageMeaningKanjiProvider extends Notifier<ImageMeaningKanjiData> {
  @override
  ImageMeaningKanjiData build() {
    return ImageMeaningKanjiData(kanji: '', link: '');
  }

  void fetchData(String kanjiCharacter) {
    final imagesLinks = dbFirebase.collection("sectionPictures");
    imagesLinks.where("kanji", isEqualTo: kanjiCharacter).get().then(
      (querySnapshot) {
        final kanjiData = querySnapshot.docs.first.data();
        state = ImageMeaningKanjiData(
            kanji: kanjiData['kanji'] as String,
            link: kanjiData['link'] as String);
      },
      onError: (e) => state = ImageMeaningKanjiData(kanji: '', link: ''),
    );
  }

  void clearState() {
    state = ImageMeaningKanjiData(kanji: '', link: '');
  }
}

final imageMeaningKanjiProvider =
    NotifierProvider<ImageMeaningKanjiProvider, ImageMeaningKanjiData>(
        ImageMeaningKanjiProvider.new);

class ImageMeaningKanjiData {
  final String kanji;
  final String link;

  ImageMeaningKanjiData({required this.kanji, required this.link});
}
