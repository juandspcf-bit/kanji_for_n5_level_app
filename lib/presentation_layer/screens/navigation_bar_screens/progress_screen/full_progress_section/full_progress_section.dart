import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/full_progress_section_provider.dart';

class FullProgressSection extends ConsumerWidget {
  const FullProgressSection({super.key});

  Widget getScreen(FullProgressSectionData progressData) {
    return progressData.fetchingDataStatus == FetchingDataStatus.fetching
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : const Center(
            child: Text("loaded data"),
          );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressData = ref.watch(fullProgressSectionProvider);
    return Scaffold(
      appBar: AppBar(),
      body: getScreen(progressData),
    );
  }
}
