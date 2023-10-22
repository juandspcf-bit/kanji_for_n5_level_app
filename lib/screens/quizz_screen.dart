import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  String kanjiImageLinkDragged = '';
  double opacityDragged = 0;
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
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                child: Draggable<KanjiFromApi>(
                  data: widget.kanjisModel[0],
                  feedback: Text(widget.kanjisModel[0].kanjiCharacter),
                  childWhenDragging: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withOpacity(0.3),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: SvgPicture.network(
                      widget.kanjisModel[0].kanjiImageLink,
                      height: 70,
                      width: 70,
                      semanticsLabel: widget.kanjisModel[0].kanjiCharacter,
                      placeholderBuilder: (BuildContext context) => Container(
                          color: Colors.transparent,
                          height: 40,
                          width: 40,
                          child: const CircularProgressIndicator(
                            backgroundColor: Color.fromARGB(179, 5, 16, 51),
                          )),
                    ),
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
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                child: DragTarget<KanjiFromApi>(onAccept: (data) {
                  setState(() {
                    kanjiImageLinkDragged = data.kanjiImageLink;
                    opacityDragged = 1.0;
                  });
                }, builder: (ctx, _, __) {
                  return Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withOpacity(opacityDragged),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: SvgPicture.network(
                          kanjiImageLinkDragged,
                          height: 70,
                          width: 70,
                          semanticsLabel: widget.kanjisModel[0].kanjiCharacter,
                          placeholderBuilder: (BuildContext context) =>
                              Container(
                            color: Colors.transparent,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        thickness: 10.5,
                        height: 5,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(widget.kanjisModel[0].englishMeaning),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(widget.kanjisModel[0].hiraganaMeaning)
                    ],
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
