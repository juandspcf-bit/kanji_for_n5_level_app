import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class KanjiDragTargetCorrect extends StatefulWidget {
  const KanjiDragTargetCorrect({
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

  @override
  State<KanjiDragTargetCorrect> createState() => _KanjiDragTargetCorrectState();
}

class _KanjiDragTargetCorrectState extends State<KanjiDragTargetCorrect> {
  bool isDown = true;
  double scale = 1.0;

  void _scaleWidget() {
    logger.d('change scale $scale , $isDown');
    if (isDown) {
      scale = 1;
      isDown = false;
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          scale = 1.3;
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              scale = 1;
            });
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDragged &&
        widget.randomSolution.kanjiCharacter ==
            widget.randomKanjisToAskMeaning.kanjiCharacter &&
        widget.imagePathFromDraggedItem != "") {
      _scaleWidget();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            showIsCorrectAnswerWidget(
              isDragged: widget.isDragged,
              randomSolution: widget.randomSolution,
              imagePathFromDraggedItem: widget.imagePathFromDraggedItem,
              randomKanjisToAskMeaning: widget.randomKanjisToAskMeaning,
            ),
            const SizedBox(
              width: 10,
            ),
            AnimatedScale(
              curve: Curves.easeInOutBack,
              scale: scale,
              duration: const Duration(seconds: 1),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withOpacity(widget.initialOpacitie),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  border: Border.all(color: Colors.white),
                ),
                child: showDraggedKanji(
                  widget.imagePathFromDraggedItem,
                  widget.randomSolution,
                  widget.randomKanjisToAskMeaning,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(cutEnglishMeaning(widget.randomSolution.englishMeaning)),
        const SizedBox(
          height: 2,
        ),
        Text('kunyomi: ${cutWords(widget.randomSolution.hiraganaMeaning)}'),
        const SizedBox(
          height: 2,
        ),
        Text('Onyomi: ${cutWords(widget.randomSolution.katakanaMeaning)}'),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class KanjiDragTargetWrong extends StatefulWidget {
  const KanjiDragTargetWrong({
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

  @override
  State<KanjiDragTargetWrong> createState() => _KanjiDragTargetWrongState();
}

class _KanjiDragTargetWrongState extends State<KanjiDragTargetWrong> {
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

  bool isDown = true;
  double turn = 0;

  void _scaleWidget() {
    logger.d('change scale $turn , $isDown');
    if (isDown) {
      turn = 0;
      isDown = false;
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          turn = 1;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDragged &&
        widget.randomSolution.kanjiCharacter !=
            widget.randomKanjisToAskMeaning.kanjiCharacter &&
        widget.imagePathFromDraggedItem != "") {
      _scaleWidget();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            showIsCorrectAnswerWidget(
              isDragged: widget.isDragged,
              randomSolution: widget.randomSolution,
              imagePathFromDraggedItem: widget.imagePathFromDraggedItem,
              randomKanjisToAskMeaning: widget.randomKanjisToAskMeaning,
            ),
            const SizedBox(
              width: 10,
            ),
            AnimatedRotation(
              turns: turn,
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOutBack,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withOpacity(widget.initialOpacitie),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  border: Border.all(color: Colors.white),
                ),
                child: showDraggedKanji(
                  widget.imagePathFromDraggedItem,
                  widget.randomSolution,
                  widget.randomKanjisToAskMeaning,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(cutEnglishMeaning(widget.randomSolution.englishMeaning)),
        const SizedBox(
          height: 2,
        ),
        Text('kunyomi: ${cutWords(widget.randomSolution.hiraganaMeaning)}'),
        const SizedBox(
          height: 2,
        ),
        Text('Onyomi: ${cutWords(widget.randomSolution.katakanaMeaning)}'),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class KanjiDragTargetNormal extends StatefulWidget {
  const KanjiDragTargetNormal({
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

  @override
  State<KanjiDragTargetNormal> createState() => _KanjiDragTargetNormalState();
}

class _KanjiDragTargetNormalState extends State<KanjiDragTargetNormal> {
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

  bool isDown = true;
  double scale = 1.0;

  void _scaleWidget() {
    logger.d('change scale $scale , $isDown');
    if (scale == 1 && isDown) {
      logger.d('scaling');
      scale = 2;
      isDown = false;
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {});
      });
    } else if (scale == 2 && !isDown) {
      scale = 1;
      isDown = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDragged &&
        widget.randomSolution.kanjiCharacter ==
            widget.randomKanjisToAskMeaning.kanjiCharacter &&
        widget.imagePathFromDraggedItem != "") {
      _scaleWidget();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            showIsCorrectAnswerWidget(
              isDragged: widget.isDragged,
              randomSolution: widget.randomSolution,
              imagePathFromDraggedItem: widget.imagePathFromDraggedItem,
              randomKanjisToAskMeaning: widget.randomKanjisToAskMeaning,
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
                    .withOpacity(widget.initialOpacitie),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(color: Colors.white),
              ),
              child: showDraggedKanji(
                widget.imagePathFromDraggedItem,
                widget.randomSolution,
                widget.randomKanjisToAskMeaning,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(cutEnglishMeaning(widget.randomSolution.englishMeaning)),
        const SizedBox(
          height: 2,
        ),
        Text('kunyomi: ${cutWords(widget.randomSolution.hiraganaMeaning)}'),
        const SizedBox(
          height: 2,
        ),
        Text('Onyomi: ${cutWords(widget.randomSolution.katakanaMeaning)}'),
        const SizedBox(
          height: 10,
        ),
      ],
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

Widget showIsCorrectAnswerWidget({
  required bool isDragged,
  required KanjiFromApi randomSolution,
  required KanjiFromApi randomKanjisToAskMeaning,
  required String imagePathFromDraggedItem,
}) {
  if (isDragged &&
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
