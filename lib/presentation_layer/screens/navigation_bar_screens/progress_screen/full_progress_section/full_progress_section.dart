import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/body_full_progress_section_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/body_full_progress_section_portrait.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/full_progress_section_provider.dart';

class FullProgressSectionScreen extends ConsumerWidget {
  const FullProgressSectionScreen({
    super.key,
    required this.section,
  });

  final int section;

  Widget getScreen(BuildContext context, FullProgressSectionData progressData) {
    final orientation = MediaQuery.orientationOf(context);
    return progressData.fetchingDataStatus == FetchingDataStatus.fetching
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : orientation == Orientation.portrait
            ? BodyFullProgressSectionPortrait(
                quizSectionData: progressData.quizSectionData,
              )
            : BodyFullProgressSectionLandscape(
                quizSectionData: progressData.quizSectionData,
              );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressData =
        ref.watch(fullProgressSectionProvider(section: section));
    return Scaffold(
      appBar: AppBar(),
      body: getScreen(
        context,
        progressData,
      ),
    );
  }
}
