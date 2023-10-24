import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/main.dart';
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
  late List<String> imageLinksFromDraggedItems;
  late List<double> initialOpacities;
  late List<bool> isDraggeInitialList;
  late List<bool> isCorrectAnswer;
  late List<bool> isChecked;
  late List<bool> isOmittedAnswer;
  late List<KanjiFromApi> randomKanjisToAskMeaning;
  late List<KanjiFromApi> randomSolutions;
  late int index;

  (List<String>, List<double>, List<bool>, List<bool>, List<bool>, List<bool>)
      initLinks(int lenght) {
    final initialLinks = <String>[];
    final initialOpacities = <double>[];
    final isDraggedList = <bool>[];
    final isCorrectAnswerList = <bool>[];
    final isOmittedList = <bool>[];
    final isCheckedList = <bool>[];
    for (int i = 0; i < lenght; i++) {
      initialLinks.add("");
      initialOpacities.add(0.0);
      isDraggedList.add(false);
      isCorrectAnswerList.add(false);
      isOmittedList.add(false);
      isCheckedList.add(false);
    }
    return (
      initialLinks,
      initialOpacities,
      isDraggedList,
      isCorrectAnswerList,
      isOmittedList,
      isCheckedList
    );
  }

  List<KanjiFromApi> suffleData() {
    final copy1 = [...widget.kanjisModel];
    copy1.shuffle();
    return copy1;
  }

  List<KanjiFromApi> getPosibleSolutions(KanjiFromApi kanjiToRemove) {
    final copy1 = [...randomKanjisToAskMeaning];
    copy1.remove(kanjiToRemove);
    final copy2 = [kanjiToRemove, ...copy1.sublist(0, 2)];
    copy2.shuffle();
    return copy2;
  }

  void showSnackBarQuizz(String message, int duration) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    randomKanjisToAskMeaning = suffleData();
    index = 0;
    randomSolutions = getPosibleSolutions(randomKanjisToAskMeaning[index]);
    final initValues = initLinks(widget.kanjisModel.length);
    imageLinksFromDraggedItems = initValues.$1;
    initialOpacities = initValues.$2;
    isDraggeInitialList = initValues.$3;
    isCorrectAnswer = initValues.$4;
    isOmittedAnswer = initValues.$5;
    isChecked = initValues.$6;
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
              height: 20,
            ),
            Text(
              'Question ${index + 1} of ${randomKanjisToAskMeaning.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20,
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
                        data: randomKanjisToAskMeaning[index],
                        feedback: Text(
                            randomKanjisToAskMeaning[index].kanjiCharacter),
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
                            randomKanjisToAskMeaning[index].kanjiImageLink,
                            height: 70,
                            width: 70,
                            semanticsLabel:
                                randomKanjisToAskMeaning[index].kanjiCharacter,
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
                      Row(
                        children: [
                          DragTarget<KanjiFromApi>(onAccept: (data) {
                            setState(() {
                              imageLinksFromDraggedItems[i] =
                                  data.kanjiImageLink;
                              initialOpacities[i] = 1.0;
                              isDraggeInitialList[index] = true;
                              isCorrectAnswer[index] =
                                  randomSolutions[i].kanjiCharacter ==
                                      randomKanjisToAskMeaning[index]
                                          .kanjiCharacter;
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
                                  child: imageLinksFromDraggedItems[i] == ''
                                      ? null
                                      : SvgPicture.network(
                                          imageLinksFromDraggedItems[i],
                                          height: 70,
                                          width: 70,
                                          semanticsLabel:
                                              randomSolutions[i].kanjiCharacter,
                                          placeholderBuilder:
                                              (BuildContext context) =>
                                                  Container(
                                            color: Colors.transparent,
                                            height: 70,
                                            width: 70,
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
                                Text(
                                    'kunyomi: ${randomSolutions[i].hiraganaMeaning}'),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                    'Onyomi: ${randomSolutions[i].katakanaMeaning}'),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      final isDraggedList = <bool>[];
                      final isDraggegImageLink = <String>[];
                      final opacityValues = <double>[];
                      for (int i = 0; i < widget.kanjisModel.length; i++) {
                        isDraggedList.add(false);
                        isDraggegImageLink.add("");
                        opacityValues.add(0.0);
                      }
                      setState(() {
                        isDraggeInitialList = [...isDraggedList];
                        isCorrectAnswer = [...isDraggedList];
                        imageLinksFromDraggedItems = [...isDraggegImageLink];
                        initialOpacities = [...opacityValues];
                        isChecked[index] = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
/*                       minimumSize: Size.fromHeight(
                          (Theme.of(context).textTheme.bodyLarge!.height ??
                                  30) +
                              10), */
                    ),
                    child: const Text("Reset question"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isDraggeInitialList[index]) {
                        showSnackBarQuizz(
                            "Please drag to one of the posible solutions", 3);
                        return;
                      } else if (isCorrectAnswer[index]) {
                        showSnackBarQuizz("Correct answer", 3);
                      } else {
                        showSnackBarQuizz("Incorrect answer", 3);
                      }
                      setState(() {
                        isChecked[index] = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
/*                       minimumSize: Size.fromHeight(
                          (Theme.of(context).textTheme.bodyLarge!.height ??
                                  30) +
                              10), */
                    ),
                    child: const Text('Check Result'),
                  ),
                ),
                /* ,*/
              ],
            ),
            if (index == widget.kanjisModel.length - 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.bodyLarge,
/*                         minimumSize: Size.fromHeight(
                            (Theme.of(context).textTheme.bodyLarge!.height ??
                                    30) +
                                10), */
                      ),
                      onPressed: () {
                        setState(() {
                          randomKanjisToAskMeaning = suffleData();
                          index = 0;
                          randomSolutions = getPosibleSolutions(
                              randomKanjisToAskMeaning[index]);
                          final initValues =
                              initLinks(widget.kanjisModel.length);
                          imageLinksFromDraggedItems = initValues.$1;
                          initialOpacities = initValues.$2;
                          isDraggeInitialList = initValues.$3;
                          isCorrectAnswer = initValues.$4;
                          isOmittedAnswer = initValues.$5;
                          isChecked = initValues.$6;
                        });
                      },
                      child: const Text('Restart Quiz'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.bodyLarge,
                        /* minimumSize: Size.fromHeight(
                            (Theme.of(context).textTheme.bodyLarge!.height ??
                                    30) +
                                10), */
                      ),
                      onPressed: () {
                        setState(() {
                          /* randomKanjisToAskMeaning = suffleData();
                          index = 0;
                          randomSolutions = getPosibleSolutions(
                              randomKanjisToAskMeaning[index]);
                          final initValues =
                              initLinks(widget.kanjisModel.length);
                          imageLinksFromDraggedItems = initValues.$1;
                          initialOpacities = initValues.$2;
                          isDraggeInitialList = initValues.$3;
                          isCorrectAnswer = initValues.$4;
                          isOmittedAnswer = initValues.$5;
                          isChecked = initValues.$6; */
                        });
                      },
                      child: const Text('Check your score'),
                    ),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (!isDraggeInitialList[index]) {
                      isOmittedAnswer[index] = true;
                    }
                    setState(() {
                      index++;
                      randomSolutions =
                          getPosibleSolutions(randomKanjisToAskMeaning[index]);
                      final initValues = initLinks(widget.kanjisModel.length);
                      imageLinksFromDraggedItems = initValues.$1;
                      initialOpacities = initValues.$2;
                      isDraggeInitialList = initValues.$3;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
/*                         minimumSize: Size.fromHeight(
                            (Theme.of(context).textTheme.bodyLarge!.height ??
                                    30) +
                                10), */
                  ),
                  icon: const Icon(Icons.arrow_circle_right),
                  label: isChecked[index]
                      ? const Text('Next')
                      : const Text('Omit'),
                ),
              )
          ],
        ),
      ),
    );
  }
}
