import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/kanji_item.dart';

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
