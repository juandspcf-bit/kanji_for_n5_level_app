import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/providers/on_boarding_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/onBoarding_screen/pages_portrait.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingFlowPortrait extends ConsumerStatefulWidget {
  const OnBoardingFlowPortrait({super.key});

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
    FinalBoardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) FlutterNativeSplash.remove();
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              children: [...myScreens],
              onPageChanged: (index) {
                if (index != (myScreens.length - 1) &&
                    texNext == context.l10n.doneOnboarding) {
                  setState(() {
                    texNext = context.l10n.nextOnboarding;
                  });
                } else if (index == myScreens.length - 1) {
                  setState(() {
                    texNext = context.l10n.doneOnboarding;
                  });
                }
              },
            ),
            Container(
              alignment: const Alignment(0, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(myScreens.length - 1);
                    },
                    child: Text(context.l10n.skipOnboarding),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: myScreens.length,
                  ),
                  TextButton(
                    onPressed: () {
                      if (_controller.page == myScreens.length - 1) {
                        ref
                            .read(onBoardingFlowProvider.notifier)
                            .setOnBoardingDone();
                        return;
                      }
                      if (_controller.page == myScreens.length - 2) {
                        setState(() {
                          texNext = context.l10n.doneOnboarding;
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
    );
  }
}
