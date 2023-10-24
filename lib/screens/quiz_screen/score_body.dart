import 'package:flutter/material.dart';

class ScoreBody extends StatefulWidget {
  const ScoreBody(
      {super.key,
      required this.isCorrectAnswer,
      required this.isOmittedAnswer});

  final List<bool> isCorrectAnswer;
  final List<bool> isOmittedAnswer;

  @override
  State<ScoreBody> createState() => _ScoreBodyState();
}

class _ScoreBodyState extends State<ScoreBody> {
  
  
  (int, int, int) getCounts() {
    int countCorrects = widget.isCorrectAnswer.map((e) {
      if (e == true) {
        return 1;
      }
      return 0;
    }).reduce((value, element) => value + element);
    int countIncorrects = widget.isCorrectAnswer.length - countCorrects;

    int countOmited = widget.isOmittedAnswer.map((e) {
      if (e == true) {
        return 1;
      }
      return 0;
    }).reduce((value, element) => value + element);

    return (countCorrects, countIncorrects, countOmited);
  }

  @override
  void initState() {
    super.initState();
    getCounts();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("score"),
    );
  }
}
