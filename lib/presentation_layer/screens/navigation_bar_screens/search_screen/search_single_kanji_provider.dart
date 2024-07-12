import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_single_kanji_provider.g.dart';

@riverpod
class SearchSingleKanji extends _$SearchSingleKanji {
  @override
  FutureOr<KanjiFromApi> build({required String kanjiCharacter}) async {
    return ref.read(kanjiApiServiceProvider).requestSingleKanjiToApi(
          kanjiCharacter,
          0,
        );
  }
}
