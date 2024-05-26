import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/body_full_progress_section.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/full_progress_section_provider.dart';

class FullProgressSection extends ConsumerWidget {
  const FullProgressSection({super.key});

  Widget getScreen(BuildContext context, FullProgressSectionData progressData) {
    final orientation = MediaQuery.orientationOf(context);
    ;
    return progressData.fetchingDataStatus == FetchingDataStatus.fetching
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : BodyFullProgressSectionLandscape(
            quizSectionData: progressData.quizSectionData,
          );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressData = ref.watch(fullProgressSectionProvider);
    return Scaffold(
      appBar: AppBar(),
      body: getScreen(
        context,
        progressData,
      ),
    );
  }
}
