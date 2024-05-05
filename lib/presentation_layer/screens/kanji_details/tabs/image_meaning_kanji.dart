import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/image_meaning_kanji_provider.dart';

class ImageMeaningKanji extends ConsumerWidget {
  const ImageMeaningKanji({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageData = ref.watch(imageMeaningKanjiProvider);
    if (imageData.link == '') {
      return LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxWidth * 427 / 640;
          return SizedBox(
            height: height,
            width: height,
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    }

    final height = 800 * imageData.linkHeight / imageData.linkWidth;

    return imageData.storageImageDetailsStatus ==
            StorageImageDetailsStatus.stored
        ? Image.file(
            File(imageData.link),
            cacheWidth: 800,
            cacheHeight: height.ceil(),
          )
        : CachedNetworkImage(
            memCacheWidth: 800,
            memCacheHeight: height.ceil(),
            imageUrl: imageData.link,
            progressIndicatorBuilder: (ctx, text, porgress) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final height = constraints.maxWidth * 427 / 640;
                  return SizedBox(
                    height: height,
                    width: height,
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              );
            },
          );
  }
}
