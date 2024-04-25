import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_connection_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/examples_audios.dart';

class TabExamples extends ConsumerWidget {
  const TabExamples({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityData = ref.watch(statusConnectionProvider);
    final kanjiDetailsData = ref.watch(kanjiDetailsProvider);
    final kanjiFromApi = kanjiDetailsData!.kanjiFromApi;
    final statusStorage = kanjiDetailsData.statusStorage;
    return connectivityData == ConnectionStatus.noConnected &&
            kanjiFromApi.statusStorage == StatusStorage.onlyOnline
        ? const ErrorConnectionScreen(
            message:
                'No internet connection, you will be able to acces the info when the connection is restored')
        : Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "Examples",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ExampleAudios(
                  examples: kanjiFromApi.example,
                  statusStorage: statusStorage,
                ),
              ),
            ],
          );
  }
}
