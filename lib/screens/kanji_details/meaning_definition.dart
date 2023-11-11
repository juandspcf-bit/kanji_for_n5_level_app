import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeaningAndDefinition extends ConsumerWidget {
  const MeaningAndDefinition({
    super.key,
    required this.englishMeaning,
    required this.hiraganaMeaning,
    required this.katakanaMeaning,
  });

  final String englishMeaning;
  final String hiraganaMeaning;
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
          "Meaning and definition",
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
            Text(
              capitalizeString('Meaning: $englishMeaning'),
            ),
          ],
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
            Text("Kunyomi: $hiraganaMeaning"),
          ],
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
            Text("Onyomi: $katakanaMeaning"),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
