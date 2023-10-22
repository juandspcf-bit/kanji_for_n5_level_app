import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.kanjisModel,
  });

  final List<KanjiFromApi> kanjisModel;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String kanjiDragged = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test your knowledge")),
      body: Row(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Draggable<KanjiFromApi>(
                  data: widget.kanjisModel[0],
                  feedback: Text(widget.kanjisModel[0].kanjiCharacter),
                  childWhenDragging: Container(
                    width: 70,
                    height: 70,
                    color: const Color.fromARGB(97, 255, 193, 7),
                  ),
                  child: Container(
                    width: 70,
                    height: 70,
                    color: Colors.amber,
                    child: Center(
                        child: Text(widget.kanjisModel[0].kanjiCharacter)),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: DragTarget<KanjiFromApi>(onAccept: (data) {
                  setState(() {
                    kanjiDragged = data.kanjiCharacter;
                  });
                }, builder: (ctx, _, __) {
                  return Container(
                    width: 70,
                    height: 70,
                    color: Colors.amber,
                    child: Center(child: Text(kanjiDragged)),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
