import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';

class IconFavorites extends ConsumerWidget {
  const IconFavorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiDetailsData = ref.watch(kanjiDetailsProvider);
    return Builder(
      builder: (context) {
        if (kanjiDetailsData!.storingToFavoritesStatus ==
            StoringToFavoritesStatus.processing) {
          return LayoutBuilder(
            builder: (ctx, constrains) {
              final height = constrains.maxHeight;
              logger.d(height);
              return SizedBox(
                width: height - 15,
                height: height - 15,
                child: const CircularProgressIndicator(),
              );
            },
          );
        }

        return Icon(kanjiDetailsData.favoriteStatus
            ? Icons.favorite
            : Icons.favorite_border_outlined);
      },
    );
  }
}
