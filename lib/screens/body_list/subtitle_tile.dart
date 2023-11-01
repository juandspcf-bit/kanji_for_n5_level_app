import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class SubTitleTile extends StatelessWidget {
  const SubTitleTile({
    super.key,
    required this.accessToKanjiItemsButtons,
    required this.kanjiFromApi,
    required this.navigateToKanjiDetails,
  });

  final bool accessToKanjiItemsButtons;
  final KanjiFromApi kanjiFromApi;
  final void Function(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) navigateToKanjiDetails;

  String cutWords(String text) {
    final splitText = text.split('、');
    if (splitText.length == 1) return text;
    return '${splitText[0]}, ${splitText[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: accessToKanjiItemsButtons
          ? () {
              navigateToKanjiDetails(context, kanjiFromApi);
            }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kunyomi: ${cutWords(kanjiFromApi.hiraganaMeaning)}",
            style: accessToKanjiItemsButtons
                ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(1.0))
                : Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.5)),
          ),
          Text(
            "Onyomi:${cutWords(kanjiFromApi.katakanaMeaning)}",
            style: accessToKanjiItemsButtons
                ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(1.0))
                : Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}