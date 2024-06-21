import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class LottieFilesProvider extends Notifier<ScoreKanjiListData> {
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

final lottieFilesProvider =
    NotifierProvider<LottieFilesProvider, ScoreKanjiListData>(
        LottieFilesProvider.new);

class ScoreKanjiListData {
  final LottieComposition? lottieComposition;

  ScoreKanjiListData({required this.lottieComposition});
}
