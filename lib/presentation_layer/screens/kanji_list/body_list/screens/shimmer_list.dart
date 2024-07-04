import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends ConsumerWidget {
  const ShimmerList({
    super.key,
  });

  Widget _getListWidgets(
    Orientation orientation,
    ScreenSizeWidth widthScreen,
    ScreenSelection selection,
    WidgetRef ref,
  ) {
    if (Orientation.portrait == orientation) {
      return ListView.builder(
        itemCount: 15,
        itemBuilder: (ctx, index) {
          return const ContainerShimmerItem();
        },
      );
    } else if (Orientation.landscape == orientation &&
        (ScreenSizeWidth.large == widthScreen ||
            ScreenSizeWidth.extraLarge == widthScreen)) {
      return SafeArea(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio:
                selection == ScreenSelection.favoritesKanjis ? 9 / 3 : 10 / 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: 15,
          itemBuilder: (ctx, index) {
            return const ContainerShimmerItem();
          },
        ),
      );
    } else if (Orientation.landscape == orientation &&
        (ScreenSizeWidth.large != widthScreen ||
            ScreenSizeWidth.extraLarge != widthScreen)) {
      return SafeArea(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio:
                selection == ScreenSelection.favoritesKanjis ? 6 / 3 : 8 / 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: 15,
          itemBuilder: (ctx, index) {
            return const ContainerShimmerItem();
          },
        ),
      );
    } else {
      return ListView.builder(
        itemCount: 15,
        itemBuilder: (ctx, index) {
          return const ContainerShimmerItem();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final widthScreen = getScreenSizeWidth(context);
    final mainScreenData = ref.watch(mainScreenProvider);
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade700,
        highlightColor: Colors.white,
        child: _getListWidgets(
          orientation,
          widthScreen,
          mainScreenData.selection,
          ref,
        ),
      ),
    );
  }
}

class ContainerShimmerItem extends StatelessWidget {
  const ContainerShimmerItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    width: double.infinity,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
