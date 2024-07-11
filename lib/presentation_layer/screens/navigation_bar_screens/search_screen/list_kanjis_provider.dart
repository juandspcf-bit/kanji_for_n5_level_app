import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_kanjis_provider.g.dart';

@riverpod
class ListKanjisState extends _$ListKanjisState {
  @override
  FutureOr<({List<String> kanjisCharacters})> build() async {
    return (kanjisCharacters: <String>[]);
  }
}
