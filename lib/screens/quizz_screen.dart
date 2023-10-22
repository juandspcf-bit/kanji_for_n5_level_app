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
  late (List<KanjiFromApi>, List<KanjiFromApi>) randomData;

  (List<String>, List<double>) initLinks(int lenght) {
    final initialLinks = <String>[];
    final initialOpacities = <double>[];
    for (int i = 0; i < lenght; i++) {
      initialLinks.add("");
      initialOpacities.add(0.0);
    }
    return (initialLinks, initialOpacities);
  }

  (List<KanjiFromApi>, List<KanjiFromApi>) suffleData() {
    final copy1 = [...widget.kanjisModel];
    final copy2 = [...widget.kanjisModel];

    copy1.shuffle();
    copy2.shuffle();

    return (copy1, copy2);
  }

  @override
  void initState() {
    super.initState();
    final initValues = initLinks(widget.kanjisModel.length);
    kanjiImageLinksDrag = initValues.$1;
    initialOpacities = initValues.$2;
    randomData = suffleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test your knowledge")),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Column(
              children: [
                for (final randomDataItem1 in randomData.$1)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                    child: Draggable<KanjiFromApi>(
                      data: randomDataItem1,
                      feedback: Text(randomDataItem1.kanjiCharacter),
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
                          randomDataItem1.kanjiImageLink,
                          height: 70,
                          width: 70,
                          semanticsLabel: randomDataItem1.kanjiCharacter,
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
                for (int i = 0; i < randomData.$2.length; i++)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                    child: DragTarget<KanjiFromApi>(onAccept: (data) {
                      setState(() {
                        kanjiImageLinksDrag[i] = data.kanjiImageLink;
                        initialOpacities[i] = 1.0;
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
                            ),
                            child: SvgPicture.network(
                              kanjiImageLinksDrag[i],
                              height: 70,
                              width: 70,
                              semanticsLabel: randomData.$2[i].kanjiCharacter,
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
                          Text(randomData.$2[i].englishMeaning),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(randomData.$2[i].hiraganaMeaning)
                        ],
                      );
                    }),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
