// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/body_list/status_operations_dialogs.dart';

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
        ScaffoldMessenger.of(context).clearSnackBars();
        ref
            .read(mainScreenProvider.notifier)
            .selectPage(index, context, statusDBStoringDialog);
      },
      selectedIndex: mainScreenData.selection.index,
      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.book,
          ),
          label: "Sections",
        ),
        NavigationDestination(
          icon: Icon(
            Icons.star,
          ),
          label: "Favorites",
        ),
        NavigationDestination(
          icon: Icon(
            Icons.search,
          ),
          label: "Basic search",
        ),
        NavigationDestination(
          icon: Icon(
            Icons.timeline,
          ),
          label: "Progress",
        ),
      ],
    );
  }
}
