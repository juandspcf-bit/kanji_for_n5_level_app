import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_score_screen.dart';
import 'package:kanji_for_n5_level_app/providers/score_kanji_list_provider.dart';
import 'package:lottie/lottie.dart';

class VisibleLottieFile extends ConsumerStatefulWidget {
  const VisibleLottieFile({super.key});

  @override
  ConsumerState<VisibleLottieFile> createState() => _VisibleLottieFileState();
}

class _VisibleLottieFileState extends ConsumerState<VisibleLottieFile> {
  double _opacity = 1.0;
  bool _visibility = true;
  @override
  void initState() {
    super.initState();
    Future<double>.delayed(const Duration(seconds: 3), () => 0.0).then((value) {
      setState(() {
        _opacity = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final scores = ref.watch(quizDetailsScoreProvider);
    final lottieFilesState = ref.watch(lottieFilesProvider);
    return Visibility(
      visible: (_visibility &&
          scores.incorrectAnwers.isEmpty &&
          scores.omitted.isEmpty),
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 3000),
        // The green box must be a child of the AnimatedOpacity widget.
        child: Lottie(
          composition: lottieFilesState.lottieComposition,
        ),
        onEnd: () {
          setState(() {
            _visibility = false;
          });
        },
      ),
    );
  }
}
