import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlassCardScreen extends ConsumerWidget {
  const FlassCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 0,
        ),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.white70,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset('assets/images/flashcard.jpeg')),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
