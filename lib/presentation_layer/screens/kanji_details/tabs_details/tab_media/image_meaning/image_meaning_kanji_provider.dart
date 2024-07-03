import 'package:kanji_for_n5_level_app/application_layer/services.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_meaning_kanji_provider.g.dart';

@riverpod
Future<ImageDetailsLinkData> imageMeaningKanji(ImageMeaningKanjiRef ref,
    {required String kanjiCharacter}) async {
  final imageDetailsStored =
      await ref.read(localDBServiceProvider).loadImageDetails(
            kanjiCharacter,
            ref.read(authServiceProvider).userUuid ?? '',
          );

  if (imageDetailsStored.kanji != '') {
    return ImageDetailsLinkData(
      kanji: imageDetailsStored.kanji,
      link: imageDetailsStored.link,
      linkHeight: imageDetailsStored.linkHeight,
      linkWidth: imageDetailsStored.linkWidth,
      storageImageDetailsStatus: StorageImageDetailsStatus.stored,
    );
  } else {
    final kanjiData =
        await ref.read(cloudDBServiceProvider).fetchKanjiData(kanjiCharacter);

    return ImageDetailsLinkData(
      kanji: kanjiData['kanji'] as String,
      link: kanjiData['link'] as String,
      linkHeight: kanjiData['linkHeight'],
      linkWidth: kanjiData['linkWidth'],
      storageImageDetailsStatus: StorageImageDetailsStatus.online,
    );
  }
}

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
