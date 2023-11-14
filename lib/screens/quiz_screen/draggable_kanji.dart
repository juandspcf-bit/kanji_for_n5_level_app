import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class DraggableKanji extends ConsumerWidget {
  final bool isDragged;
  final KanjiFromApi randomKanjisToAskMeaning;

  const DraggableKanji({
    super.key,
    required this.isDragged,
    required this.randomKanjisToAskMeaning,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isDragged
        ? Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer
                  .withOpacity(0),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(color: Colors.white),
            ),
          )
        : Draggable<KanjiFromApi>(
            data: randomKanjisToAskMeaning,
            feedback: Text(randomKanjisToAskMeaning.kanjiCharacter),
            childWhenDragging: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(0),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(color: Colors.white),
              ),
            ),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: randomKanjisToAskMeaning.statusStorage ==
                      StatusStorage.onlyOnline
                  ? SvgPicture.network(
                      randomKanjisToAskMeaning.kanjiImageLink,
                      height: 70,
                      width: 70,
                      semanticsLabel: randomKanjisToAskMeaning.kanjiCharacter,
                      placeholderBuilder: (BuildContext context) => Container(
                          color: Colors.transparent,
                          height: 40,
                          width: 40,
                          child: const CircularProgressIndicator(
                            backgroundColor: Color.fromARGB(179, 5, 16, 51),
                          )),
                    )
                  : SvgPicture.file(
                      File(randomKanjisToAskMeaning.kanjiImageLink),
                      height: 70,
                      width: 70,
                      semanticsLabel: randomKanjisToAskMeaning.kanjiCharacter,
                      placeholderBuilder: (BuildContext context) => Container(
                          color: Colors.transparent,
                          height: 40,
                          width: 40,
                          child: const CircularProgressIndicator(
                            backgroundColor: Color.fromARGB(179, 5, 16, 51),
                          )),
                    ),
            ),
          );
  }
}
