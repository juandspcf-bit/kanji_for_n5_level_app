import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/svg_utils.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class LeadingTile extends StatelessWidget {
  const LeadingTile({
    super.key,
    required this.kanjiFromApi,
  });

  final KanjiFromApi kanjiFromApi;

  Widget setSVGwidget(BuildContext context) {
    if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline ||
        kanjiFromApi.statusStorage == StatusStorage.processingStoring) {
      return SvgNetwork(
        imageUrl: kanjiFromApi.kanjiImageLink,
        semanticsLabel: kanjiFromApi.kanjiCharacter,
      );
    } else if (kanjiFromApi.statusStorage == StatusStorage.stored ||
        kanjiFromApi.statusStorage == StatusStorage.processingDeleting) {
      return SvgFile(
        imagePath: kanjiFromApi.kanjiImageLink,
        semanticsLabel: kanjiFromApi.kanjiCharacter,
      );
    } else {
      return SvgPicture.asset(
        'assets/images/question-mark-2-svgrepo-com.svg',
        fit: BoxFit.contain,
        semanticsLabel: kanjiFromApi.kanjiCharacter,
        placeholderBuilder: (BuildContext context) => Container(
            color: Colors.transparent,
            child: const CircularProgressIndicator(
              backgroundColor: Color.fromARGB(179, 5, 16, 51),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = 80;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: kanjiFromApi.accessToKanjiItemsButtons
            ? Theme.of(context)
                .colorScheme
                .onSecondaryContainer
                .withOpacity(1.0)
            : Theme.of(context)
                .colorScheme
                .onSecondaryContainer
                .withOpacity(0.5),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: setSVGwidget(context),
    );
  }
}
