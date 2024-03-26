import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class CacheKanjiList extends Notifier<List<KanjiFromApi>> {
  @override
  List<KanjiFromApi> build() {
    return [];
  }
}
