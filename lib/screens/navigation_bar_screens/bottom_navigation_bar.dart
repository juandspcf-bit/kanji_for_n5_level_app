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
    return Container(
      foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors
                  .white38) //Border(top: BorderSide(color: Colors.white38, width: 1)),
          ),
      child: BottomNavigationBar(
        unselectedItemColor: Colors.white30,
        selectedItemColor: Colors.white70,
        //Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(100),
        onTap: selectPage,
        currentIndex: selectedPageIndex.index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              size: iconSize,
            ),
            label: "Sections",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
              size: iconSize,
            ),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: iconSize,
            ),
            label: "basic search",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.timeline,
              size: iconSize,
            ),
            label: "progress",
          ),
        ],
      ),
    );
  }
}
