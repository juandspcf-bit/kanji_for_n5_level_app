import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class BodyFullProgressSection extends ConsumerWidget {
  const BodyFullProgressSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            ListTile(
              leading: SizedBox(
                height: 50,
                width: 50,
                child: SimpleCircularProgressBar(
                  size: 50,
                  progressStrokeWidth: 5,
                  backStrokeWidth: 5,
                  startAngle: 0,
                  animationDuration: 0,
                  progressColors: const [Colors.amber],
                  valueNotifier: ValueNotifier(50),
                ),
              ),
              title: const Text("audio progress"),
            )
          ],
        ),
      ),
    ) /* SingleChildScrollView(
      child: Column(
        children: [
          Text("data"),
          /* ListTile(
            trailing: GFProgressBar(
                percentage: 0.9,
                width: 100,
                radius: 90,
                type: GFProgressType.circular,
                backgroundColor: Colors.black26,
                progressBarColor: GFColors.DANGER),
            title: const Text("audio example for "),
          ) */
        ],
      ),
    ) */
        ;
  }
}
