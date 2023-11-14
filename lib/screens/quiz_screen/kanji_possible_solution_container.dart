import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class KanjiDragTarget extends ConsumerWidget {
  const KanjiDragTarget({
    super.key,
    required this.isDragged,
    required this.randomSolution,
    required this.randomKanjisToAskMeaning,
    required this.imagePathFromDraggedItem,
    required this.initialOpacitie,
  });

  final bool isDragged;
  final KanjiFromApi randomSolution;
  final KanjiFromApi randomKanjisToAskMeaning;
  final String imagePathFromDraggedItem;
  final double initialOpacitie;

  Widget showIsCorrectAnswerWidget({
    required bool isDragged,
    required KanjiFromApi randomSolution,
    required KanjiFromApi randomKanjisToAskMeaning,
    required String imagePathFromDraggedItem,
  }) {
    if (isDragged == true &&
        randomSolution.kanjiCharacter ==
            randomKanjisToAskMeaning.kanjiCharacter &&
        imagePathFromDraggedItem != "") {
      return const Icon(
        Icons.done,
        color: Colors.amberAccent,
        size: 40,
      );
    } else if (isDragged == true &&
        randomSolution.kanjiCharacter !=
            randomKanjisToAskMeaning.kanjiCharacter &&
        imagePathFromDraggedItem != "") {
      return const Icon(
        Icons.close,
        color: Colors.amberAccent,
        size: 40,
      );
    } else {
      return Container();
    }
  }

  Widget? showDraggedKanji(String path, KanjiFromApi randomSolution,
      KanjiFromApi randomKanjisToAskMeaning) {
    if (path == '') return null;

    if (randomKanjisToAskMeaning.statusStorage == StatusStorage.onlyOnline) {
      return SvgPicture.network(
        path,
        height: 70,
        width: 70,
        semanticsLabel: randomSolution.kanjiCharacter,
        placeholderBuilder: (BuildContext context) => Container(
          color: Colors.transparent,
          height: 70,
          width: 70,
        ),
      );
    } else {
      return SvgPicture.file(
        File(path),
        height: 70,
        width: 70,
        semanticsLabel: randomSolution.kanjiCharacter,
        placeholderBuilder: (BuildContext context) => Container(
          color: Colors.transparent,
          height: 70,
          width: 70,
        ),
      );
    }
  }

  String cutWords(String text) {
    final splitText = text.split('、');
    if (splitText.length == 1) return text;
    return '${splitText[0]}, ${splitText[1]}';
  }

  String cutEnglishMeaning(String text) {
    final splitText = text.split(', ');
    if (splitText.length == 1) return text;
    return '${splitText[0]}, ${splitText[1]}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            showIsCorrectAnswerWidget(
              isDragged: isDragged,
              randomSolution: randomSolution,
              imagePathFromDraggedItem: imagePathFromDraggedItem,
              randomKanjisToAskMeaning: randomKanjisToAskMeaning,
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(initialOpacitie),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(color: Colors.white),
              ),
              child: showDraggedKanji(
                imagePathFromDraggedItem,
                randomSolution,
                randomKanjisToAskMeaning,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(cutEnglishMeaning(randomSolution.englishMeaning)),
        const SizedBox(
          height: 2,
        ),
        Text('kunyomi: ${cutWords(randomSolution.hiraganaMeaning)}'),
        const SizedBox(
          height: 2,
        ),
        Text('Onyomi: ${cutWords(randomSolution.katakanaMeaning)}'),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
