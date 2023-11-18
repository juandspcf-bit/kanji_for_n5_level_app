import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/image_meaning_kanji_provider.dart';

class ImageMeaningKanji extends ConsumerStatefulWidget {
  const ImageMeaningKanji({super.key});

  @override
  ConsumerState<ImageMeaningKanji> createState() => _ImageMeaningKanjiState();
}

class _ImageMeaningKanjiState extends ConsumerState<ImageMeaningKanji> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ref.watch(imageMeaningKanjiProvider).link;
    if (imageUrl == '') {
      return LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxWidth * 427 / 640;
          return SizedBox(
              height: height,
              width: height,
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ));
        },
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      progressIndicatorBuilder: (ctx, text, porgress) {
        return const CircularProgressIndicator.adaptive();
      },
    );
  }
}
