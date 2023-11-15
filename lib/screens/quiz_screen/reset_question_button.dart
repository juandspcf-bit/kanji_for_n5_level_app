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
          textStyle: Theme.of(context).textTheme.bodyLarge,
          minimumSize: Size.fromHeight(
              (Theme.of(context).textTheme.bodyLarge!.height ?? 30) + 10),
        ),
        child: const Text("Reset question"),
      ),
    );
  }
}
