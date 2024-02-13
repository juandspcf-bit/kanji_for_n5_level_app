// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar(
      {super.key, required this.selectedPageIndex, required this.selectPage});

  final ScreenSelection selectedPageIndex;
  final void Function(
    int index,
  ) selectPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationBar(
      onDestinationSelected: selectPage,
      selectedIndex: selectedPageIndex.index,
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
