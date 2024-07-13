import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_kanjis_provider.g.dart';

@riverpod
class ListKanjisState extends _$ListKanjisState {
  @override
  FutureOr<({List<String> kanjisCharacters})> build() async {
    return (kanjisCharacters: <String>[],);
  }

  void searchKanjisByGrade(int grade) async {
    state = const AsyncLoading();
    final result =
        await ref.read(kanjiApiServiceProvider).getKanjisByGrade(grade);
    state = AsyncValue.data((kanjisCharacters: result));
  }
}

enum SearchingGradeState { searching, noStarted, data, error }
