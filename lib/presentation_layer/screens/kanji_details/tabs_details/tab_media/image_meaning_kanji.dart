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
            memCacheHeight: imageData.linkWidth == 0 ? 100 : height.ceil(),
            imageUrl: imageData.link,
            errorWidget: (context, url, error) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final height = constraints.maxWidth * 427 / 640;
                  return Container(
                    height: height,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Icon(
                        Icons.error,
                        color: Colors.amber,
                        size: 50,
                      ),
                    ),
                  );
                },
              );
            },
            progressIndicatorBuilder: (ctx, text, progress) {
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
