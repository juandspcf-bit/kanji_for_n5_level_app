import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class LeadingTile extends StatelessWidget {
  const LeadingTile({
    super.key,
    required this.kanjiFromApi,
    required this.navigateToKanjiDetails,
  });

  final KanjiFromApi kanjiFromApi;
  final void Function(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) navigateToKanjiDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: kanjiFromApi.accessToKanjiItemsButtons
          ? () {
              navigateToKanjiDetails(context, kanjiFromApi);
            }
          : null,
      child: Container(
        height: 80,
        width: 60,
        decoration: BoxDecoration(
            color: kanjiFromApi.accessToKanjiItemsButtons
                ? Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(1.0)
                : Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: kanjiFromApi.statusStorage == StatusStorage.onlyOnline ||
                kanjiFromApi.statusStorage == StatusStorage.proccessing
            ? SvgPicture.network(
                kanjiFromApi.kanjiImageLink,
                fit: BoxFit.contain,
                semanticsLabel: kanjiFromApi.kanjiCharacter,
                placeholderBuilder: (BuildContext context) => Container(
                    color: Colors.transparent,
                    height: 100,
                    width: 100,
                    child: const CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(179, 5, 16, 51),
                    )),
              )
            : SvgPicture.file(
                File(kanjiFromApi.kanjiImageLink),
                fit: BoxFit.contain,
                semanticsLabel: kanjiFromApi.kanjiCharacter,
                placeholderBuilder: (BuildContext context) => Container(
                    color: Colors.transparent,
                    height: 100,
                    width: 100,
                    child: const CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(179, 5, 16, 51),
                    )),
              ),
      ),
    );
  }
}
