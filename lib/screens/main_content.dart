import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_providers.dart';
import 'package:kanji_for_n5_level_app/screens/favorites_kanjis_screen.dart';
import 'package:kanji_for_n5_level_app/screens/sections_screen.dart';

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void getListOfFavorites() async {
    final querySnapshot = await dbFirebase.collection("favorites").get();
    myFavoritesCached = querySnapshot.docs.map(
      (e) {
        Map<String, dynamic> data = e.data();
        return (e.id, 'kanjiCharacter', data['kanjiCharacter'] as String);
      },
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    getListOfFavorites();
  }

  Widget selectScreen(int selectedPageIndex) {
    switch (selectedPageIndex) {
      case 0:
        return const Column(
          children: [
            Expanded(
              child: Sections(),
            ),
          ],
        );
      case 1:
        return const FavoritesKanjisScreen(
          isFromTabNav: true,
        );

      default:
        return const Center(
          child: Text("no screen"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    String scaffoldTitle = "Welcome juan";
    if (_selectedPageIndex == 1) scaffoldTitle = "Favorites";

    return Scaffold(
      appBar: AppBar(
        title: Text(scaffoldTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 3, right: 3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: CachedNetworkImage(
                imageUrl: temporalAvatar,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ],
      ),
      body: selectScreen(_selectedPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        selectedItemColor: Theme.of(context).colorScheme.onSecondaryContainer,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSecondaryContainer.withAlpha(100),
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Sections",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}
