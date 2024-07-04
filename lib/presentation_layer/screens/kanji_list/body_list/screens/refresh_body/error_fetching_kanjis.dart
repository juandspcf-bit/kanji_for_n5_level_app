import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/models/section_model.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/list_favorite_kanjis_screen/favorites_kanjis_provider.dart';

class ErrorFetchingKanjisScreen extends ConsumerWidget {
  const ErrorFetchingKanjisScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainScreenData = ref.watch(mainScreenProvider);
    return LayoutBuilder(
      builder: (ctx, viewportConstraints) {
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
                          context.l10n.errorLoading,
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
