import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/on_boarding_provider.dart';
import 'package:kanji_for_n5_level_app/screens/onBoarding_screen/pages.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyPageViewer extends ConsumerStatefulWidget {
  const MyPageViewer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyPageViewerState();
}

class _MyPageViewerState extends ConsumerState {
  final PageController _controller = PageController();
  var texNext = 'next';

  final List<Widget> myScreens = const [
    WelcomeOnBoardScreen(),
    SectionOnBoardScreen(),
    ListOnBoardScreen(),
    DetailsOnBoardScreen(),
    QuizOnBoardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              children: [...myScreens],
              onPageChanged: (index) {
                if (index != (myScreens.length - 1) && texNext == 'done') {
                  setState(() {
                    texNext = 'next';
                  });
                } else if (index == myScreens.length - 1) {
                  setState(() {
                    texNext = 'done';
                  });
                }
              },
            ),
            Container(
              alignment: const Alignment(0, 0.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(myScreens.length - 1);
                    },
                    child: const Text('skip'),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: myScreens.length,
                  ),
                  TextButton(
                    onPressed: () {
                      if (_controller.page == myScreens.length - 1) {
                        ref
                            .read(onBoardingProvider.notifier)
                            .setOnBoardingDone();
                        return;
                      }
                      if (_controller.page == myScreens.length - 2) {
                        setState(() {
                          texNext = 'done';
                        });
                      }
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.bounceIn);
                    },
                    child: Text(texNext),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
