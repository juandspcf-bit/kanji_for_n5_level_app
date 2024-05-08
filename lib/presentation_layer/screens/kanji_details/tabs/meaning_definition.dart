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
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
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
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(221, 62, 61, 64),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SelectableText(
                capitalizeString('${context.l10n.meaning}: $englishMeaning'),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(221, 62, 61, 64),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  SelectableText("Kunyomi(romaji): $hiraganaRomaji"),
                  const SizedBox(
                    height: 5,
                  ),
                  SelectableText("Kunyomi: $hiraganaMeaning"),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(221, 62, 61, 64),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText("Onyomi(romaji): $katakanaRomaji"),
                  const SizedBox(
                    height: 5,
                  ),
                  SelectableText("Onyomi: $katakanaMeaning"),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
