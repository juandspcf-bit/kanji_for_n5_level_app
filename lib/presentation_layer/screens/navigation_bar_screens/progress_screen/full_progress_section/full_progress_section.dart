import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_screens.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/body_full_progress_section_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/body_full_progress_section_portrait.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/full_progress_section_provider.dart';

class FullProgressSectionScreen extends ConsumerWidget {
  const FullProgressSectionScreen({
    super.key,
    required this.section,
  });

  final int section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final progressData =
        ref.watch(fullProgressSectionProvider(section: section));
    return Scaffold(
      appBar: AppBar(),
      body: progressData.when(
        data: (data) {
          return orientation == Orientation.portrait
              ? BodyFullProgressSectionPortrait(
                  quizSectionData: data.quizSectionData,
                )
              : BodyFullProgressSectionLandscape(
                  quizSectionData: data.quizSectionData,
                );
        },
        error: (_, __) =>
            const ErrorScreen(message: "Error loading data", icon: Icons.error),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
