import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/onBoarding_screen/on_boarding_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/onBoarding_screen/on_boarding_portrait.dart';

class OnBoardingScreen extends ConsumerWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    return Orientation.portrait == orientation
        ? const OnBoardingFlowPortrait()
        : const OnBoardingFlowLandscape();
  }
}
