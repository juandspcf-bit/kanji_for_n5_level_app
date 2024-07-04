import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/screens/refresh_body/refresh_body_lis.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/screens/refresh_body/error_fetching_kanjis.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/screens/shimmer_list.dart';

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
    if (statusResponse == 2) {
      return const ErrorFetchingKanjisScreen();
    } else if (statusResponse == 0) {
      return const SafeArea(
        child: ShimmerList(),
      );
    } else {
      return RefreshBodyList(
        statusResponse: statusResponse,
        kanjisFromApi: kanjisFromApi,
      );
    }
  }
}
