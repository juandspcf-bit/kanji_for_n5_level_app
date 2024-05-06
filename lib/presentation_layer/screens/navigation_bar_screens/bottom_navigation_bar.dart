// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/l10n/locazition.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/status_operations_dialogs.dart';

class CustomBottomNavigationBar extends ConsumerWidget
    with StatusDBStoringDialogs {
  const CustomBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainScreenData = ref.watch(mainScreenProvider);
    return NavigationBar(
      onDestinationSelected: (index) {
        ref.read(toastServiceProvider).dismiss(context);
        ref
            .read(mainScreenProvider.notifier)
            .selectPage(index, context, statusDBStoringDialog);
      },
      selectedIndex: mainScreenData.selection.index,
      destinations: [
        NavigationDestination(
          icon: const Icon(
            Icons.book,
          ),
          label: context.l10n.sectiosNavBar,
        ),
        NavigationDestination(
          icon: const Icon(
            Icons.star,
          ),
          label: context.l10n.favoritesNavBar,
        ),
        NavigationDestination(
          icon: const Icon(
            Icons.search,
          ),
          label: context.l10n.basicSearchNavBar,
        ),
        NavigationDestination(
          icon: const Icon(
            Icons.timeline,
          ),
          label: context.l10n.progressNavBar,
        ),
      ],
    );
  }
}
