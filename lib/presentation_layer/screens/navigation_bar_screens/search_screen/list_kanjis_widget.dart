import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/list_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_single_kanji_screen.dart';

class ListKanjisWidget extends ConsumerWidget {
  const ListKanjisWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listKanjiState = ref.watch(listKanjisStateProvider);

    return listKanjiState.when(
      data: (data) => ListView.builder(
        itemCount: data.kanjisCharacters.length,
        itemBuilder: (context, index) => Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(seconds: 1),
                  reverseTransitionDuration: const Duration(seconds: 1),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return SearchSingleKanjiScreen(
                        kanjiCharacter: data.kanjisCharacters[index]);
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOutBack,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              ),
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  data.kanjisCharacters[index],
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
            const Divider()
          ],
        ),
      ),
      error: (_, e) {
        logger.e(e);
        return const Center(
          child: Text("error"),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
