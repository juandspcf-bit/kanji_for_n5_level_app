import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_screen.dart';

class SearchOptionsPortrait extends ConsumerWidget {
  const SearchOptionsPortrait({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      MediaQuery.orientationOf(context) == Orientation.portrait
                          ? const Size.fromHeight(50)
                          : const Size(300, 50),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(seconds: 1),
                      reverseTransitionDuration: const Duration(seconds: 1),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SearchScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: Tween<double>(
                            begin: 0,
                            end: 1,
                          ).animate(
                            animation.drive(
                              CurveTween(
                                curve: Curves.easeInOutBack,
                              ),
                            ),
                          ),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                label: const Text("search for a kanji"),
                icon: const Icon(Icons.search),
              )
            ],
          ),
        ),
      ),
    );
  }
}
