import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/onBoarding_screen/firts_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyPageViewer extends ConsumerStatefulWidget {
  const MyPageViewer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyPageViewerState();
}

class _MyPageViewerState extends ConsumerState {
  final PageController _controller = PageController();

  final List<Widget> myScreens = const [
    WelcomeOnBoardScreen(),
    SectionOnBoardScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [...myScreens],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: SmoothPageIndicator(
              controller: _controller,
              count: myScreens.length,
            ),
          )
        ],
      ),
    );
  }
}
