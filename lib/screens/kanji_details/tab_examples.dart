import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/examples_audios.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/meaning_definition.dart';

class TabExamples extends ConsumerWidget {
  const TabExamples({
    super.key,
    required this.kanjiFromApi,
    required this.statusStorage,
    required this.stopAnimation,
  });

  final KanjiFromApi kanjiFromApi;
  final StatusStorage statusStorage;
  final void Function() stopAnimation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        MeaningAndDefinition(
          englishMeaning: kanjiFromApi.englishMeaning,
          hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
          katakanaMeaning: kanjiFromApi.katakanaMeaning,
        ),
        const Divider(
          height: 4,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "Examples",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ExampleAudios(
            examples: kanjiFromApi.example,
            stopAnimation: stopAnimation,
            statusStorage: statusStorage,
          ),
        ),
      ],
    );
  }
}
