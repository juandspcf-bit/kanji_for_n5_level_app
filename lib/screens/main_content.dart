import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/Databases/download_db_utils.dart';
import 'package:kanji_for_n5_level_app/Databases/favorites_db_utils.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/favorite_screen.dart';
import 'package:kanji_for_n5_level_app/screens/sections_screen.dart';
import 'package:permission_handler/permission_handler.dart';

const temporalAvatar =
    "https://firebasestorage.googleapis.com/v0/b/kanji-for-n5.appspot.com/o/unnamed.jpg?alt=media&token=38275fec-42f3-4d95-b1fd-785e82d4086f&_gl=1*19p8v1f*_ga*MjAyNTg0OTcyOS4xNjk2NDEwODIz*_ga_CW55HF8NVT*MTY5NzEwMTY3NC45LjEuMTY5NzEwMzExMy4zMy4wLjA.";

Dio dio = Dio();

class MainContent extends ConsumerStatefulWidget {
  const MainContent({super.key});

  @override
  ConsumerState<MainContent> createState() => _MainContentState();
}

class _MainContentState extends ConsumerState<MainContent> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      if (index == 1) {
        ref.read(kanjiListProvider.notifier).clearKanjiList();
        final storedKanjis =
            ref.read(statusStorageProvider.notifier).getStoresItems();
        ref.read(kanjiListProvider.notifier).setKanjiList(
            storedKanjis.values.fold([], (previousValue, element) {
                  previousValue!.addAll(element);
                  return previousValue;
                }) ??
                [],
            ref
                .read(favoritesCachedProvider.notifier)
                .getFavorites()
                .map((e) => e.kanjiCharacter)
                .toList(),
            10);
      }
      _selectedPageIndex = index;
    });
  }

  void getInitData() async {
    final listOfStoredKanjis = await loadStoredKanjis();
    ref
        .read(statusStorageProvider.notifier)
        .setInitialStoredKanjis(listOfStoredKanjis);
    final favoritesKanjis = await loadFavorites();
    ref
        .read(favoritesCachedProvider.notifier)
        .setInitialFavorites(listOfStoredKanjis, favoritesKanjis, 10);
    /* final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isAskedStoragePermission = prefs.getBool('isAskedStoragePermission');
    if (isAskedStoragePermission == null || isAskedStoragePermission == false) {
      final isGrantedPermission = await _requestWritePermission();
      await prefs.setBool('isAskedStoragePermition', true);
      await prefs.setBool('isGrantedPermission', isGrantedPermission);  
    }else{
      prefs.getBool('isGrantedPermission');
    } */
  }

/*   Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  } */

  @override
  void initState() {
    super.initState();
    getInitData();
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
        return const FavoriteScreen();

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
