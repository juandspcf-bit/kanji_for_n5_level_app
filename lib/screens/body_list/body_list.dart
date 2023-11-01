import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/kanji_item.dart';

class BodyKanjisList extends ConsumerWidget {
  const BodyKanjisList({
    super.key,
    required this.statusResponse,
    required this.kanjisFromApi,
  });

  final int statusResponse;
  final List<KanjiFromApi> kanjisFromApi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('status response $statusResponse');
    if (statusResponse == 0) {
      return const Center(child: CircularProgressIndicator());
    } else if (statusResponse == 1 && kanjisFromApi.isNotEmpty) {
      return ListView.builder(
          itemCount: kanjisFromApi.length,
          itemBuilder: (ctx, index) {
            return KanjiItem(
              key: ValueKey(kanjisFromApi[index].kanjiCharacter),
              kanjiFromApi: kanjisFromApi[index],
            );
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
    } else if (statusResponse == 1 && kanjisFromApi.isEmpty) {
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
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No state to match',
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
                Icons.question_mark,
                color: Theme.of(context).colorScheme.primary,
                size: 80,
              ),
            ],
          )
        ],
      );
    }
  }
}
