import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class BodyKanjisList extends StatelessWidget {
  const BodyKanjisList({
    super.key,
    required this.statusResponse,
    required this.kanjisModel,
    required this.navigateToKanjiDetails,
  });

  final int statusResponse;
  final List<KanjiFromApi> kanjisModel;
  final void Function(BuildContext, KanjiFromApi?) navigateToKanjiDetails;

  Widget buildTree(BuildContext context, int statusResponse,
      List<KanjiFromApi> kanjisModel) {
    if (statusResponse == 0) {
      return const Center(child: CircularProgressIndicator());
    } else if (statusResponse == 1) {
      return ListView.builder(
          itemCount: kanjisModel.length,
          itemBuilder: (ctx, index) {
            return KanjiItem(
              key: ValueKey(kanjisModel[index].kanjiCharacter),
              kanjiFromApi: kanjisModel[index],
              navigateToKanjiDetails: navigateToKanjiDetails,
            ); //Text('${kanjisModel[index].kanjiCharacter} : ${kanjisModel[index].englishMeaning}');
          });
    } else if (statusResponse == 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'An error has occurr',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.amber,
                size: 80,
              ),
            ],
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No data to show',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.data_usage,
                color: Theme.of(context).colorScheme.primary,
                size: 80,
              ),
            ],
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildTree(context, statusResponse, kanjisModel);
  }
}

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            Expanded(
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
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          style: BorderStyle.solid, color: Colors.white70),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        kanjiFromApi.englishMeaning,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Kunyomi: ${kanjiFromApi.hiraganaMeaning}"),
                      Text("Onyomi: ${kanjiFromApi.katakanaMeaning}"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
