import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_kanji_list_provider.dart';

class ResetQuestionButton extends ConsumerWidget {
  const ResetQuestionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () {
          ref.read(quizDataValuesProvider.notifier).onResetQuestion();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
        ),
        child: const Text("Reset question"),
      ),
    );
  }
}
