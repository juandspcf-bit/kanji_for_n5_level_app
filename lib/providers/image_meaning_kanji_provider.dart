import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class ImageMeaningKanjiProvider extends Notifier<ImageDetailsLinkData> {
  @override
  ImageDetailsLinkData build() {
    return ImageDetailsLinkData(
      kanji: '',
      link: '',
      linkHeight: 0,
      linkWidth: 0,
      storageImageDetailsStatus: StorageImageDetailsStatus.online,
    );
  }

  void fetchData(String kanjiCharacter) async {
    try {
      final imageDetailsStored =
          await ref.read(localDBServiceProvider).loadImageDetails(
                kanjiCharacter,
                ref.read(authServiceProvider).userUuid ?? '',
              );

      if (imageDetailsStored.kanji != '') {
        state = ImageDetailsLinkData(
          kanji: imageDetailsStored.kanji,
          link: imageDetailsStored.link,
          linkHeight: imageDetailsStored.linkHeight,
          linkWidth: imageDetailsStored.linkWidth,
          storageImageDetailsStatus: StorageImageDetailsStatus.stored,
        );
        logger.d(
            'In database link ${imageDetailsStored.linkHeight} ${imageDetailsStored.linkWidth}');
      } else {
        final kanjiData = await ref
            .read(cloudDBServiceProvider)
            .fetchKanjiData(kanjiCharacter);

        state = ImageDetailsLinkData(
          kanji: kanjiData['kanji'] as String,
          link: kanjiData['link'] as String,
          linkHeight: kanjiData['linkHeight'],
          linkWidth: kanjiData['linkWidth'],
          storageImageDetailsStatus: StorageImageDetailsStatus.online,
        );
        logger.d('In cloud');
      }
    } catch (e) {
      state = ImageDetailsLinkData(
        kanji: '',
        link: '',
        linkHeight: 0,
        linkWidth: 0,
        storageImageDetailsStatus: StorageImageDetailsStatus.online,
      );
    }
  }

  void clearState() {
    state = ImageDetailsLinkData(
      kanji: '',
      link: '',
      linkHeight: 0,
      linkWidth: 0,
      storageImageDetailsStatus: StorageImageDetailsStatus.online,
    );
  }
}

final imageMeaningKanjiProvider =
    NotifierProvider<ImageMeaningKanjiProvider, ImageDetailsLinkData>(
        ImageMeaningKanjiProvider.new);

class ImageDetailsLinkData {
  final String kanji;
  final String link;
  final int linkHeight;
  final int linkWidth;
  final StorageImageDetailsStatus storageImageDetailsStatus;

  ImageDetailsLinkData({
    required this.kanji,
    required this.link,
    required this.linkHeight,
    required this.linkWidth,
    required this.storageImageDetailsStatus,
  });
}

enum StorageImageDetailsStatus { online, stored }
