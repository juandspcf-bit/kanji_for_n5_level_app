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
        kanjiFromApi.statusStorage == StatusStorage.proccessingStoring) {
      return SvgPicture.network(
        kanjiFromApi.kanjiImageLink,
        fit: BoxFit.contain,
        semanticsLabel: kanjiFromApi.kanjiCharacter,
        placeholderBuilder: (BuildContext context) => Container(
            color: Colors.transparent,
            height: 70,
            width: 70,
            child: const CircularProgressIndicator(
              backgroundColor: Color.fromARGB(179, 5, 16, 51),
            )),
      );
    } else if (kanjiFromApi.statusStorage == StatusStorage.stored ||
        kanjiFromApi.statusStorage == StatusStorage.proccessingDeleting) {
      return SvgPicture.file(
        File(kanjiFromApi.kanjiImageLink),
        fit: BoxFit.contain,
        semanticsLabel: kanjiFromApi.kanjiCharacter,
        placeholderBuilder: (BuildContext context) => Container(
            color: Colors.transparent,
            height: 70,
            width: 70,
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
      height: 70,
      width: 70,
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
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: setSVGwidget(context),
    );
  }
}
