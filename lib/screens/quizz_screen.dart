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
  late List<String> kanjiImageLinksDrag;
  late List<double> initialOpacities;
  late List<bool> isDraggeInitialList;
  late List<KanjiFromApi> randomData;
  late List<KanjiFromApi> randomSolutions;
  late int index;

  (List<String>, List<double>, List<bool>) initLinks(int lenght) {
    final initialLinks = <String>[];
    final initialOpacities = <double>[];
    final isDraggedList = <bool>[];
    for (int i = 0; i < lenght; i++) {
      initialLinks.add("");
      initialOpacities.add(0.0);
      isDraggedList.add(false);
    }
    return (initialLinks, initialOpacities, isDraggedList);
  }

  List<KanjiFromApi> suffleData() {
    final copy1 = [...widget.kanjisModel];
    copy1.shuffle();
    return copy1;
  }

  List<KanjiFromApi> getPosibleSolutions(KanjiFromApi kanjiToRemove) {
    final copy1 = [...randomData];
    copy1.remove(kanjiToRemove);
    final copy2 = [kanjiToRemove, ...copy1.sublist(0, 2)];
    copy2.shuffle();
    return copy2;
  }

  @override
  void initState() {
    super.initState();
    final initValues = initLinks(widget.kanjisModel.length);
    kanjiImageLinksDrag = initValues.$1;
    initialOpacities = initValues.$2;
    isDraggeInitialList = initValues.$3;
    randomData = suffleData();
    index = 0;
    randomSolutions = getPosibleSolutions(randomData[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test your knowledge")),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 0,
          bottom: 0,
          right: 30,
          left: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isDraggeInitialList[index] == true
                    ? Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withOpacity(0),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(color: Colors.white),
                        ),
                      )
                    : Draggable<KanjiFromApi>(
                        data: randomData[index],
                        feedback: Text(randomData[index].kanjiCharacter),
                        childWhenDragging: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer
                                .withOpacity(0),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(color: Colors.white),
                          ),
                        ),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: SvgPicture.network(
                            randomData[index].kanjiImageLink,
                            height: 70,
                            width: 70,
                            semanticsLabel: randomData[index].kanjiCharacter,
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                                    color: Colors.transparent,
                                    height: 40,
                                    width: 40,
                                    child: const CircularProgressIndicator(
                                      backgroundColor:
                                          Color.fromARGB(179, 5, 16, 51),
                                    )),
                          ),
                        ),
                      ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < randomSolutions.length; i++)
                      DragTarget<KanjiFromApi>(onAccept: (data) {
                        setState(() {
                          kanjiImageLinksDrag[i] = data.kanjiImageLink;
                          initialOpacities[i] = 1.0;
                          isDraggeInitialList[index] = true;
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
                                    .withOpacity(initialOpacities[i]),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(color: Colors.white),
                              ),
                              child: SvgPicture.network(
                                kanjiImageLinksDrag[i],
                                height: 70,
                                width: 70,
                                semanticsLabel:
                                    randomSolutions[i].kanjiCharacter,
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
                            Text(randomSolutions[i].englishMeaning),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(randomSolutions[i].hiraganaMeaning)
                          ],
                        );
                      }),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_circle_left),
                  label: const Text('previous'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_circle_right),
                  label: const Text('next'),
                  //style: ElevatedButtonTheme.of(context).style!.copyWith(minimumSize: 150),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
