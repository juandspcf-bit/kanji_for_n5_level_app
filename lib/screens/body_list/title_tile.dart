import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class TitleTile extends StatelessWidget {
  const TitleTile({
    super.key,
    required this.kanjiFromApi,
    required this.navigateToKanjiDetails,
  });

  final KanjiFromApi kanjiFromApi;

  final void Function(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) navigateToKanjiDetails;

  String cutEnglishMeaning(String text) {
    final splitText = text.split(', ');
    if (splitText.length == 1) return text;
    return '${splitText[0]}, ${splitText[1]}';
  }

  Widget setTitlewidget(BuildContext context) {
    if (kanjiFromApi.statusStorage != StatusStorage.errorDeleting) {
      return Text(
        cutEnglishMeaning(kanjiFromApi.englishMeaning),
        textAlign: TextAlign.start,
        style: kanjiFromApi.accessToKanjiItemsButtons
            ? Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white.withOpacity(1.0),
                fontWeight: FontWeight.bold)
            : Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.bold),
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
      child: setTitlewidget(context),
    );
  }
}
