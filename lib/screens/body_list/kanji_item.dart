import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/Databases/download_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class KanjiItem extends StatelessWidget {
  const KanjiItem({
    super.key,
    required this.kanjiFromApi,
    required this.navigateToKanjiDetails,
    required this.statusStorage,
  });

  final KanjiFromApi kanjiFromApi;
  final void Function(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) navigateToKanjiDetails;
  final StatusStorage statusStorage;

  void downloadKanji(KanjiFromApi kanjiFromApi) {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
      onTap: () {
        navigateToKanjiDetails(context, kanjiFromApi);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: SvgPicture.network(
                kanjiFromApi.kanjiImageLink,
                height: 80,
                width: 80,
                semanticsLabel: kanjiFromApi.kanjiCharacter,
                placeholderBuilder: (BuildContext context) => Container(
                    color: Colors.transparent,
                    height: 40,
                    width: 40,
                    child: const CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(179, 5, 16, 51),
                    )),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            ContainerDefinitions(
              kanjiFromApi: kanjiFromApi,
              statusStorage: statusStorage,
            )
          ],
        ),
      ),
    );
  }
}

class ContainerDefinitions extends ConsumerStatefulWidget {
  const ContainerDefinitions({
    super.key,
    required this.kanjiFromApi,
    required this.statusStorage,
  });

  final KanjiFromApi kanjiFromApi;
  final StatusStorage statusStorage;

  @override
  ConsumerState<ContainerDefinitions> createState() =>
      ContainerDefinitionsState();
}

class ContainerDefinitionsState extends ConsumerState<ContainerDefinitions> {
  late Widget statusStorageWidget;

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
    if (widget.statusStorage == StatusStorage.onlyOnline) {
      return const Icon(
        Icons.download_for_offline,
        size: 50,
      );
    } else if (widget.statusStorage == StatusStorage.stored) {
      return const Icon(
        Icons.storage,
        size: 50,
      );
    }

    return const Icon(
      Icons.question_mark,
      size: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    statusStorageWidget = selectWidgetStatus();
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [
            Color.fromARGB(180, 250, 8, 8),
            Color.fromARGB(180, 192, 20, 20),
            Color.fromARGB(70, 121, 21, 21)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cutEnglishMeaning(widget.kanjiFromApi.englishMeaning),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                      //textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Kunyomi: ${cutWords(widget.kanjiFromApi.hiraganaMeaning)}",
                    ),
                    Text(
                      "Onyomi:${cutWords(widget.kanjiFromApi.katakanaMeaning)}",
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      statusStorageWidget = const CircularProgressIndicator();
                    });
                    if (widget.statusStorage == StatusStorage.onlyOnline) {
                      insertKanjiFromApi(widget.kanjiFromApi).then((value) {
                        ref
                            .read(statusStorageProvider.notifier)
                            .addItem(widget.kanjiFromApi);
                      }).catchError((onError) {});
                    } else if (widget.statusStorage == StatusStorage.stored) {
                      deleteKanjiFromApi(widget.kanjiFromApi).then((value) {
                        ref
                            .read(statusStorageProvider.notifier)
                            .deleteItem(widget.kanjiFromApi);
                      }).catchError((onError) {});
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    padding:
                        const EdgeInsets.only(left: 30, top: 30, bottom: 30),
                    child: statusStorageWidget,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
