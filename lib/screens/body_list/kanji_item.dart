import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/Databases/download_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class KanjiItem extends StatelessWidget {
  const KanjiItem({
    super.key,
    required this.kanjiFromApi,
    required this.navigateToKanjiDetails,
  });

  final KanjiFromApi kanjiFromApi;
  final void Function(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) navigateToKanjiDetails;

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
            )
          ],
        ),
      ),
    );
  }
}

class ContainerDefinitions extends StatefulWidget {
  const ContainerDefinitions({
    super.key,
    required this.kanjiFromApi,
  });

  final KanjiFromApi kanjiFromApi;

  @override
  State<StatefulWidget> createState() => ContainerDefinitionsState();
}

class ContainerDefinitionsState extends State<ContainerDefinitions> {
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
  Widget build(BuildContext context) {
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
                    insertKanjiFromApi(widget.kanjiFromApi);
                  },
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    padding:
                        const EdgeInsets.only(left: 30, top: 30, bottom: 30),
                    child: const Icon(
                      Icons.download_for_offline,
                      size: 50,
                    ),
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
