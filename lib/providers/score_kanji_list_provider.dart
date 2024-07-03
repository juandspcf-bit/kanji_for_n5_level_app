import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lottie/lottie.dart';

part 'score_kanji_list_provider.g.dart';

@Riverpod(keepAlive: true)
class LottieFilesObject extends _$LottieFilesObject {
  @override
  ScoreKanjiListData build() {
    return ScoreKanjiListData(lottieComposition: null);
  }

  void initLottieFile() async {
    if (state.lottieComposition != null) return;
    final lottieComposition =
        await AssetLottie('assets/lottie_files/congrats.json').load();
    state = ScoreKanjiListData(lottieComposition: lottieComposition);
  }
}

class ScoreKanjiListData {
  final LottieComposition? lottieComposition;

  ScoreKanjiListData({required this.lottieComposition});
}
