import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/locazition.dart';

class MeaningAndDefinition extends ConsumerWidget {
  const MeaningAndDefinition({
    super.key,
    required this.englishMeaning,
    required this.hiraganaRomaji,
    required this.hiraganaMeaning,
    required this.katakanaRomaji,
    required this.katakanaMeaning,
  });

  final String englishMeaning;
  final String hiraganaRomaji;
  final String hiraganaMeaning;
  final String katakanaRomaji;
  final String katakanaMeaning;

  String capitalizeString(String text) {
    var firstLetter = text[0];
    firstLetter = firstLetter.toUpperCase();
    return firstLetter + text.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          context.l10n.meaningAndDefinition,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 20,
            ),
            SelectableText(
              capitalizeString('${context.l10n.meaning}: $englishMeaning'),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 20,
            ),
            SelectableText("Kunyomi(romaji): $hiraganaRomaji"),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 20,
            ),
            SelectableText("Kunyomi: $hiraganaMeaning"),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 20,
            ),
            SelectableText("Onyomi(romaji): $katakanaRomaji"),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 20,
            ),
            SelectableText("Onyomi: $katakanaMeaning"),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
