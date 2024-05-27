import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/title_main_screen_provider.dart';

class TitleMainScreen extends ConsumerWidget {
  const TitleMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleMainScreenData = ref.watch(titleMainScreenProvider);
    return titleMainScreenData.when(
      data: (data) => Text('${context.l10n.welcome} \n $data'),
      error: (error, stack) => Container(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
