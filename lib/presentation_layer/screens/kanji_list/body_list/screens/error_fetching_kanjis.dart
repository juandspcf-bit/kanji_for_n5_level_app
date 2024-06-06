import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/section_model.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';

class ErrorFetchingKanjisScreen extends ConsumerWidget {
  const ErrorFetchingKanjisScreen({
    super.key,
    required this.mainScreenData,
  });

  final MainScreenData mainScreenData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (contx, viewportConstraints) {
        return RefreshIndicator(
          onRefresh: () async {
            if (mainScreenData.selection == ScreenSelection.favoritesKanjis) {
              await ref
                  .read(favoritesKanjisProvider.notifier)
                  .fetchFavoritesOnRefresh();
              return;
            }

            final kanjiListData = ref.read(kanjiListProvider);
            final sectionModel = listSections[kanjiListData.section - 1];
            ref.read(kanjiListProvider.notifier).fetchKanjis(
                  kanjisCharacters: sectionModel.kanjisCharacters,
                  sectionNumber: kanjiListData.section,
                );
          },
          child: ListView(
            children: [
              ConstrainedBox(
                constraints: viewportConstraints.copyWith(
                  minHeight: viewportConstraints.maxHeight,
                  maxHeight: double.infinity,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'An error has occurr',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.amber,
                          size: 80,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
