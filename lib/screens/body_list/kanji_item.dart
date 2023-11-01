import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/Databases/download_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';
import 'package:kanji_for_n5_level_app/providers/access_to_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/providers/favorite_screen_selection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kaji_details.dart';

class KanjiItem extends ConsumerStatefulWidget {
  const KanjiItem({
    super.key,
    required this.kanjiFromApi,
    required this.statusStorage,
  });

  final KanjiFromApi kanjiFromApi;

  final StatusStorage statusStorage;

  @override
  ConsumerState<KanjiItem> createState() => _KanjiItemState();
}

class _KanjiItemState extends ConsumerState<KanjiItem> {
  void downloadKanji(KanjiFromApi kanjiFromApi) {}

  late Widget statusStorageWidget;
  bool isProcessing = false;

  void navigateToKanjiDetails(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) {
    if (kanjiFromApi == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) {
        return KanjiDetails(
          kanjiFromApi: kanjiFromApi,
          statusStorage: widget.statusStorage,
        );
      }),
    );
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

  Widget selectWidgetStatus() {
    if (widget.kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
      return const Icon(
        Icons.download_for_offline,
        size: 50,
      );
    } else if (widget.kanjiFromApi.statusStorage == StatusStorage.stored) {
      return const Icon(
        Icons.storage,
        size: 50,
      );
    } else if (widget.kanjiFromApi.statusStorage == StatusStorage.dowloading) {
      return const CircularProgressIndicator();
    }

    return const Icon(
      Icons.question_mark,
      size: 50,
    );
  }

  Widget getContainerWidget() {
    return Card(
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            navigateToKanjiDetails(context, widget.kanjiFromApi);
          },
          child: Container(
            height: 80,
            width: 60,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: widget.statusStorage == StatusStorage.onlyOnline ||
                    widget.statusStorage == StatusStorage.dowloading
                ? SvgPicture.network(
                    widget.kanjiFromApi.kanjiImageLink,
                    fit: BoxFit.contain,
                    semanticsLabel: widget.kanjiFromApi.kanjiCharacter,
                    placeholderBuilder: (BuildContext context) => Container(
                        color: Colors.transparent,
                        height: 100,
                        width: 100,
                        child: const CircularProgressIndicator(
                          backgroundColor: Color.fromARGB(179, 5, 16, 51),
                        )),
                  )
                : SvgPicture.file(
                    File(widget.kanjiFromApi.kanjiImageLink),
                    fit: BoxFit.contain,
                    semanticsLabel: widget.kanjiFromApi.kanjiCharacter,
                    placeholderBuilder: (BuildContext context) => Container(
                        color: Colors.transparent,
                        height: 100,
                        width: 100,
                        child: const CircularProgressIndicator(
                          backgroundColor: Color.fromARGB(179, 5, 16, 51),
                        )),
                  ),
          ),
        ),
        title: GestureDetector(
          onTap: () {
            navigateToKanjiDetails(context, widget.kanjiFromApi);
          },
          child: Text(
            cutEnglishMeaning(widget.kanjiFromApi.englishMeaning),
            textAlign: TextAlign.start,
          ),
        ),
        subtitle: GestureDetector(
          onTap: () {
            navigateToKanjiDetails(context, widget.kanjiFromApi);
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Kunyomi: ${cutWords(widget.kanjiFromApi.hiraganaMeaning)}",
            ),
            Text(
              "Onyomi:${cutWords(widget.kanjiFromApi.katakanaMeaning)}",
            ),
          ]),
        ),
        trailing: InkWell(
          onTap: () {
            final selection = ref
                .read(favoriteScreenSelectionProvider.notifier)
                .getSelection();

            if (widget.statusStorage == StatusStorage.onlyOnline) {
              insertKanjiFromApi(widget.kanjiFromApi)
                  .then((kanjiFromApiStored) {
                //print(' my stored kanji is $kanjiFromApiStored');
                ref
                    .read(statusStorageProvider.notifier)
                    .addItem(kanjiFromApiStored);

                if (selection) {
                  ref
                      .read(favoritesCachedProvider.notifier)
                      .updateKanji(kanjiFromApiStored);
                } else {
                  ref
                      .read(kanjiListProvider.notifier)
                      .updateKanji(kanjiFromApiStored);
                }
              }).catchError((onError) {
                if (selection) {
                  ref.read(favoritesCachedProvider.notifier).updateKanji(
                      updateStatusKanji(
                          StatusStorage.onlyOnline, widget.kanjiFromApi));
                } else {
                  ref.read(kanjiListProvider.notifier).updateKanji(
                      updateStatusKanji(
                          StatusStorage.onlyOnline, widget.kanjiFromApi));
                }
              }).whenComplete(() =>
                      ref.read(accesToQuizProvider.notifier).giveAccesToQuiz());
            } else if (widget.statusStorage == StatusStorage.stored) {
              deleteKanjiFromApi(widget.kanjiFromApi).then((value) {
                ref
                    .read(statusStorageProvider.notifier)
                    .deleteItem(widget.kanjiFromApi);
                RequestApi.getKanjis([], [widget.kanjiFromApi.kanjiCharacter],
                    widget.kanjiFromApi.section, (list) {
                  if (selection) {
                    ref
                        .read(favoritesCachedProvider.notifier)
                        .updateKanji(list[0]);
                  } else {
                    ref.read(kanjiListProvider.notifier).updateKanji(list[0]);
                  }
                }, () {
                  if (selection) {
                    ref.read(favoritesCachedProvider.notifier).updateKanji(
                        updateStatusKanji(
                            StatusStorage.stored, widget.kanjiFromApi));
                  } else {
                    ref.read(kanjiListProvider.notifier).updateKanji(
                        updateStatusKanji(
                            StatusStorage.stored, widget.kanjiFromApi));
                  }
                });
              }).catchError((onError) {
                if (selection) {
                  ref.read(favoritesCachedProvider.notifier).updateKanji(
                      updateStatusKanji(
                          StatusStorage.stored, widget.kanjiFromApi));
                } else {
                  ref.read(kanjiListProvider.notifier).updateKanji(
                      updateStatusKanji(
                          StatusStorage.stored, widget.kanjiFromApi));
                }
              }).whenComplete(() =>
                  ref.read(accesToQuizProvider.notifier).giveAccesToQuiz());
            }

            if (selection) {
              ref.read(favoritesCachedProvider.notifier).updateKanji(
                  updateStatusKanji(
                      StatusStorage.dowloading, widget.kanjiFromApi));
            } else {
              ref.read(accesToQuizProvider.notifier).denyAccesToQuiz();
              ref.read(kanjiListProvider.notifier).updateKanji(
                  updateStatusKanji(
                      StatusStorage.dowloading, widget.kanjiFromApi));
            }
          },
          child: Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: statusStorageWidget,
          ),
        ),
        isThreeLine: true,
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  KanjiFromApi updateStatusKanji(
      StatusStorage statusStorage, KanjiFromApi kanjiFromApi) {
    return KanjiFromApi(
        kanjiCharacter: kanjiFromApi.kanjiCharacter,
        englishMeaning: kanjiFromApi.englishMeaning,
        kanjiImageLink: kanjiFromApi.kanjiImageLink,
        katakanaMeaning: kanjiFromApi.katakanaMeaning,
        hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
        videoLink: kanjiFromApi.videoLink,
        section: kanjiFromApi.section,
        statusStorage: statusStorage,
        example: kanjiFromApi.example,
        strokes: kanjiFromApi.strokes);
  }

  @override
  Widget build(BuildContext context) {
    statusStorageWidget = selectWidgetStatus();
    return getContainerWidget();
  }
}
