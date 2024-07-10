import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_main_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class OptionsDetails extends ConsumerWidget {
  const OptionsDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiFromApi = ref.read(kanjiDetailsProvider)!.kanjiFromApi;
    final statusConnectionData = ref.read(statusConnectionProvider);

    final accessToQuiz = statusConnectionData == ConnectionStatus.noConnected &&
        kanjiFromApi.statusStorage == StatusStorage.onlyOnline;
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: !accessToQuiz
              ? () {
                  ref.read(kanjiDetailsProvider.notifier).initQuiz();

                  Navigator.of(context).push(
                    PageAnimationTransition(
                      page: const DetailsQuizScreen(),
                      pageAnimationType: FadeAnimationTransition(),
                    ),
                  );
                }
              : null,
          child: Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.quiz,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${context.l10n.quizzes}!",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton.icon(
          onPressed: () {
            ref
                .read(kanjiDetailsProvider.notifier)
                .storeToFavorites(kanjiFromApi);
          },
          icon: const IconFavoritesButton(),
          label: const TextFavoritesButton(),
          style: ElevatedButton.styleFrom().copyWith(
            minimumSize: const WidgetStatePropertyAll(
              Size(300, 40),
            ),
          ),
        ),
      ],
    ));
  }
}

class IconFavoritesButton extends ConsumerWidget {
  const IconFavoritesButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiDetailsData = ref.watch(kanjiDetailsProvider);
    return Builder(
      builder: (context) {
        if (kanjiDetailsData!.storingToFavoritesStatus ==
            StoringToFavoritesStatus.processing) {
          return SizedBox(
            width: 40 - 15,
            height: 40 - 15,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          );
        }

        return Icon(kanjiDetailsData.favoriteStatus
            ? Icons.favorite
            : Icons.favorite_border_outlined);
      },
    );
  }
}

class TextFavoritesButton extends ConsumerWidget {
  const TextFavoritesButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiDetailsData = ref.watch(kanjiDetailsProvider);
    return kanjiDetailsData!.favoriteStatus
        ? Text(context.l10n.removeFavorites)
        : Text(context.l10n.addFavorites);
  }
}
