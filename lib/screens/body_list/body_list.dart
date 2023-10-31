import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
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
    ref.watch(statusStorageProvider);
    if (statusResponse == 0) {
      return const Center(child: CircularProgressIndicator());
    } else if (statusResponse == 1) {
      return ListView.builder(
          itemCount: kanjisFromApi.length,
          itemBuilder: (ctx, index) {
            final statusStorage = ref
                .read(statusStorageProvider.notifier)
                .isInStorage(kanjisFromApi[index]);
            return KanjiItem(
              key: ValueKey(statusStorage.$2 == StatusStorage.stored
                  ? statusStorage.$1.kanjiCharacter
                  : kanjisFromApi[index].kanjiCharacter),
              kanjiFromApi: statusStorage.$2 == StatusStorage.stored
                  ? statusStorage.$1
                  : kanjisFromApi[index],
              statusStorage: statusStorage.$2,
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
}
