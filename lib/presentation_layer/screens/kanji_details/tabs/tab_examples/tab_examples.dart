import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/tab_examples/examples_audios.dart';

class TabExamples extends ConsumerWidget {
  const TabExamples({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiDetailsData = ref.watch(kanjiDetailsProvider);
    final kanjiFromApi = kanjiDetailsData!.kanjiFromApi;
    final statusStorage = kanjiDetailsData.statusStorage;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          context.l10n.examples,
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
            statusStorage: statusStorage,
          ),
        ),
      ],
    );
  }
}
