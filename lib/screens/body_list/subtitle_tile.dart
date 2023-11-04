import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class SubTitleTile extends StatelessWidget {
  const SubTitleTile({
    super.key,
    required this.kanjiFromApi,
    required this.navigateToKanjiDetails,
  });

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

  Widget setSubTitlewidget(BuildContext context) {
    if (kanjiFromApi.statusStorage != StatusStorage.errorDeleting) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kunyomi: ${cutWords(kanjiFromApi.hiraganaMeaning)}",
            style: kanjiFromApi.accessToKanjiItemsButtons
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
            style: kanjiFromApi.accessToKanjiItemsButtons
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
      );
    } else {
      return Icon(
        Icons.question_mark_rounded,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: kanjiFromApi.accessToKanjiItemsButtons
          ? () {
              navigateToKanjiDetails(context, kanjiFromApi);
            }
          : null,
      child: setSubTitlewidget(context),
    );
  }
}
