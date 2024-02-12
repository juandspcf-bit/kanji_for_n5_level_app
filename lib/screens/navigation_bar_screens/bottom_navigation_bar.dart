// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar(
      {super.key,
      required this.selectedPageIndex,
      required this.iconSize,
      required this.selectPage});

  final ScreenSelection selectedPageIndex;
  final double iconSize;
  final void Function(
    int index,
  ) selectPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationBar(
      indicatorColor: Colors.transparent,
      onDestinationSelected: selectPage,
      selectedIndex: selectedPageIndex.index,
      destinations: [
        NavigationDestination(
          icon: Container(
            decoration: BoxDecoration(
              color: selectedPageIndex.index == 0
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.elliptical(20, 20),
                right: Radius.elliptical(20, 20),
              ),
            ),
            height: iconSize,
            width: iconSize,
            child: Icon(
              Icons.book,
              size: iconSize, //iconSize,
            ),
          ),
          selectedIcon: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.elliptical(20, 20),
                  right: Radius.elliptical(20, 20),
                ),
              ),
              height: iconSize,
              width: iconSize + 30,
              child: Icon(
                Icons.book,
                size: iconSize, //iconSize,
              )),
          label: "Sections",
        ),
        NavigationDestination(
          icon: Icon(
            Icons.star,
            size: iconSize,
          ),
          label: "Favorites",
        ),
        NavigationDestination(
          icon: Icon(
            Icons.search,
            size: iconSize,
          ),
          label: "basic search",
        ),
        NavigationDestination(
          icon: Icon(
            Icons.timeline,
            size: iconSize,
          ),
          label: "progress",
        ),
      ],
    );
  }
}
