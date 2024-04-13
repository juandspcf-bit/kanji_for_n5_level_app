import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
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

Future<LottieComposition> loadLottieFileComputeVersion(String path) async {
  logger.d('inside isolate');
  return await AssetLottie(path).load();
}

final lottieFilesProvider =
    NotifierProvider<LottieFilesProvider, ScoreKnajiListData>(
        LottieFilesProvider.new);

class ScoreKnajiListData {
  final LottieComposition? lottieComposition;

  ScoreKnajiListData({required this.lottieComposition});
}
