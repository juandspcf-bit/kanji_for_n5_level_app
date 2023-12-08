// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar(
      {super.key,
      required this.selectedPageIndex,
      required this.iconSize,
      required this.selectPage});

  final int selectedPageIndex;
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
        unselectedItemColor:
            Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(100),
        onTap: selectPage,
        currentIndex: selectedPageIndex,
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
        ],
      ),
    );
  }
}
