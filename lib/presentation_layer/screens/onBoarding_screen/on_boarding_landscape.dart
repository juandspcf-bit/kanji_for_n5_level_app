import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/on_boarding_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/onBoarding_screen/pages_landscape.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingFlowLandscape extends ConsumerStatefulWidget {
  const OnBoardingFlowLandscape({super.key});

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
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) FlutterNativeSplash.remove();
    });
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: PageView(
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
              ),
              Expanded(
                flex: 1,
                child: Column(
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
                      axisDirection: Axis.vertical,
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
                            curve: Curves.ease);
                      },
                      child: Text(texNext),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
