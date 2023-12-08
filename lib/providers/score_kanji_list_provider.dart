import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class LottieFilesProvider extends Notifier<ScoreKnajiListData> {
  @override
  ScoreKnajiListData build() {
    return ScoreKnajiListData(lottieComposition: null);
  }

  void initLottieFile() async {
    final lottieComposition =
        await AssetLottie('assets/lottie_files/congrats.json').load();
    state = ScoreKnajiListData(lottieComposition: lottieComposition);
  }
}

final lottieFilesProvider =
    NotifierProvider<LottieFilesProvider, ScoreKnajiListData>(
        LottieFilesProvider.new);

class ScoreKnajiListData {
  final LottieComposition? lottieComposition;

  ScoreKnajiListData({required this.lottieComposition});
}
