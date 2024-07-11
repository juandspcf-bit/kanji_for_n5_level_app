import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';

class MeaningAndDefinition extends ConsumerWidget {
  const MeaningAndDefinition({
    super.key,
  });

  String capitalizeString(String text) {
    var firstLetter = text[0];
    firstLetter = firstLetter.toUpperCase();
    return firstLetter + text.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiFromApi = ref.read(kanjiDetailsProvider)!.kanjiFromApi;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color.fromARGB(221, 62, 61, 64),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    context.l10n.meaningAndDefinition,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SelectableText(
                  capitalizeString(
                      '${context.l10n.meaning}: ${kanjiFromApi.englishMeaning}'),
                ),
                const SizedBox(
                  height: 20,
                ),
                SelectableText(
                    "Kunyomi(romaji): ${kanjiFromApi.hiraganaRomaji}"),
                const SizedBox(
                  height: 5,
                ),
                SelectableText("Kunyomi: ${kanjiFromApi.hiraganaMeaning}"),
                const SizedBox(
                  height: 20,
                ),
                SelectableText(
                    "Onyomi(romaji): ${kanjiFromApi.katakanaRomaji}"),
                const SizedBox(
                  height: 5,
                ),
                SelectableText("Onyomi: ${kanjiFromApi.katakanaMeaning}"),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
