import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_kanjis_provider.g.dart';

@riverpod
class ListKanjisState extends _$ListKanjisState {
  @override
  FutureOr<({List<String> kanjisCharacters})> build() async {
    return (kanjisCharacters: <String>[]);
  }

  void searchKanjisByGrade(int grade) async {
    try {
      state = const AsyncLoading();
      logger.d("loading");
      final result =
          await ref.read(kanjiApiServiceProvider).getKanjisByGrade(grade);
      state = AsyncValue.data((kanjisCharacters: result));
      logger.d("finishd");
    } catch (e) {
      logger.e(e);
    }
  }
}
