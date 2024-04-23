import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/refresh_body_lis.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/error_fetching_kanjis.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/shimmer_list.dart';

class BodyKanjisList extends ConsumerWidget {
  const BodyKanjisList({
    super.key,
    required this.statusResponse,
    required this.kanjisFromApi,
    required this.mainScreenData,
  });

  final int statusResponse;
  final List<KanjiFromApi> kanjisFromApi;

  final MainScreenData mainScreenData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiListData = ref.watch(kanjiListProvider);
    if (kanjiListData.status == 2) {
      return ErrorFetchingKanjisScreen(mainScreenData: mainScreenData);
    } else if (kanjiListData.status == 0) {
      return SafeArea(
        child: ShimmerList(
          selection: mainScreenData.selection,
        ),
      );
    } else {
      return RefreshBodyList(
        statusResponse: statusResponse,
        kanjisFromApi: kanjiListData.kanjiList,
        mainScreenData: mainScreenData,
      );
    }
  }
}
