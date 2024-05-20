import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
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
      return SvgPicture.network(
        kanjiFromApi.kanjiImageLink,
        semanticsLabel: kanjiFromApi.kanjiCharacter,
        placeholderBuilder: (BuildContext context) => Container(
          height: 80,
          width: 80,
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          color: Colors.transparent,
          child: const CircularProgressIndicator(
            backgroundColor: Color.fromARGB(179, 5, 16, 51),
          ),
        ),
      );
    } else if (kanjiFromApi.statusStorage == StatusStorage.stored ||
        kanjiFromApi.statusStorage == StatusStorage.processingDeleting) {
      return SvgPicture.file(
        height: 80,
        width: 80,
        File(kanjiFromApi.kanjiImageLink),
        semanticsLabel: kanjiFromApi.kanjiCharacter,
        placeholderBuilder: (BuildContext context) => Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5),
            color: Colors.transparent,
            child: const CircularProgressIndicator(
              backgroundColor: Color.fromARGB(179, 5, 16, 51),
            )),
      );
    } else {
      return SvgPicture.asset(
        'assets/images/question-mark-2-svgrepo-com.svg',
        fit: BoxFit.contain,
        semanticsLabel: kanjiFromApi.kanjiCharacter,
        placeholderBuilder: (BuildContext context) => Container(
            color: Colors.transparent,
            height: 100,
            width: 100,
            child: const CircularProgressIndicator(
              backgroundColor: Color.fromARGB(179, 5, 16, 51),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
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
