// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/leading_tile.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/subtitle_tile.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/title_tile.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/trailing_tile.dart';
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
  var accessToKanjiItemsButtons = true;

  void navigateToKanjiDetails(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) {
    if (kanjiFromApi == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) {
        return KanjiDetails(
          kanjiFromApi: kanjiFromApi,
          statusStorage: kanjiFromApi.statusStorage,
        );
      }),
    );
  }

  void setAccessToKanjiItemsButtons(bool value) {
    setState(() {
      accessToKanjiItemsButtons = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: accessToKanjiItemsButtons
          ? Theme.of(context).cardColor.withOpacity(1)
          : Theme.of(context).cardColor.withOpacity(0.5),
      child: ListTile(
        leading: LeadingTile(
          accessToKanjiItemsButtons: accessToKanjiItemsButtons,
          kanjiFromApi: widget.kanjiFromApi,
          navigateToKanjiDetails: navigateToKanjiDetails,
        ),
        title: TitleTile(
          accessToKanjiItemsButtons: accessToKanjiItemsButtons,
          kanjiFromApi: widget.kanjiFromApi,
          navigateToKanjiDetails: navigateToKanjiDetails,
        ),
        subtitle: SubTitleTile(
          accessToKanjiItemsButtons: accessToKanjiItemsButtons,
          kanjiFromApi: widget.kanjiFromApi,
          navigateToKanjiDetails: navigateToKanjiDetails,
        ),
        trailing: TrailingTile(
          accessToKanjiItemsButtons: accessToKanjiItemsButtons,
          kanjiFromApi: widget.kanjiFromApi,
          setAccessToKanjiItemsButtons: setAccessToKanjiItemsButtons,
        ),
        isThreeLine: true,
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
