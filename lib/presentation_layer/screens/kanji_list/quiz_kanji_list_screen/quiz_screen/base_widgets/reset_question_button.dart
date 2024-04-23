import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_kanji_list_provider.dart';

class ResetQuestionButton extends ConsumerWidget {
  const ResetQuestionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton.icon(
        onPressed: () {
          ref.read(quizDataValuesProvider.notifier).onResetQuestion();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(60),
        ),
        icon: const Icon(Icons.restore_page_rounded),
        label: const Text(
          "Reset question",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
