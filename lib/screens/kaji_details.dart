import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:video_player/video_player.dart';

class KanjiDetails extends ConsumerStatefulWidget {
  const KanjiDetails({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  @override
  ConsumerState<KanjiDetails> createState() => KanjiDetailsState();
}

class KanjiDetailsState extends ConsumerState<KanjiDetails> {
  late VideoPlayerController _videoController;
  final assetsAudioPlayer = AssetsAudioPlayer();

  String capitalizeString(String text) {
    var firstLetter = text[0];
    firstLetter = firstLetter.toUpperCase();
    return firstLetter + text.substring(1);
  }

  List<Widget> getListStrokes(List<String> images) {
    List<Widget> strokes = [];
    for (int index = 0; index < images.length; index++) {
      Widget stroke = Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: GestureDetector(
              onTap: () {
                _scaleDialog(images[index], index);
              },
              child: SvgPicture.network(
                images[index],
                height: 80,
                width: 80,
                semanticsLabel: widget.kanjiFromApi.kanjiCharacter,
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
          index != images.length - 1
              ? const SizedBox(
                  width: 10,
                  child: Icon(Icons.arrow_circle_right_outlined),
                )
              : const SizedBox(
                  width: 20,
                ),
        ],
      );
      strokes.add(stroke);
    }
    return strokes;
  }

  List<Widget> getIndexedExamples(
      List<Examples> examples, Function() stopAnimation) {
    List<Widget> indexedExamples = [];
    for (int index = 0; index < examples.length; index++) {
      final tileWidget = ListTile(
        leading: Text(
          '${index + 1}._',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        title: Column(
          children: [
            Text(examples[index].japanese),
            const SizedBox(
              height: 7,
            ),
            Text(examples[index].meaning.english),
            const SizedBox(
              height: 7,
            ),
          ],
        ),
        trailing: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(30)),
          child: IconButton(
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () async {
              stopAnimation();

              final assetsAudioPlayer = AssetsAudioPlayer();

              try {
                await assetsAudioPlayer.open(
                  Audio.network(examples[index].audio.mp3),
                );
              } catch (t) {
                //mp3 unreachable
              }
            },
            icon: const Icon(Icons.play_arrow_rounded),
          ),
        ),
      );

      indexedExamples.add(tileWidget);
    }

    return indexedExamples;
  }

  void stopAnimation() {
    setState(() {
      if (_videoController.value.isPlaying) _videoController.pause();
    });
  }

  Widget _dialog(BuildContext context, String image, int index) {
    return AlertDialog(
      title: Text("Stroke number ${index + 1}"),
      content: SvgPicture.network(
        image,
        height: 120,
        width: 120,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        //color: Colors.white,
        semanticsLabel: widget.kanjiFromApi.kanjiCharacter,
        placeholderBuilder: (BuildContext context) => Container(
            color: Colors.transparent,
            height: 80,
            width: 80,
            child: const CircularProgressIndicator(
              backgroundColor: Color.fromARGB(179, 5, 16, 51),
            )),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

  void _scaleDialog(String image, int index) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx, image, index),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.kanjiFromApi.videoLink))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _videoController.setLooping(true);
          _videoController.play();
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.pause();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kanjiFromApi.kanjiCharacter),
        actions: [
          IconButton(
              onPressed: () {
                final favoriteKanji = <String, dynamic>{
                  "kanjiCharacter": widget.kanjiFromApi.kanjiCharacter,
                };
                dbFirebase.collection("favorites").add(favoriteKanji).then(
                    (DocumentReference doc) =>
                        print('DocumentSnapshot added with ID: ${doc.id}'));
              },
              icon: const Icon(Icons.favorite))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _videoController.value.isInitialized
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 100 * _videoController.value.aspectRatio,
                      width: 100,
                      child: AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(30)),
                      child: IconButton(
                        color: Theme.of(context).colorScheme.onPrimary,
                        onPressed: () {
                          setState(() {
                            _videoController.value.isPlaying
                                ? _videoController.pause()
                                : _videoController.play();
                          });
                        },
                        icon: Icon(
                          _videoController.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 128 * _videoController.value.aspectRatio,
                        width: 128,
                        child: const Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(),
                        )),
                  ],
                ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 4,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Strokes",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...getListStrokes(widget.kanjiFromApi.strokes.images)
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 4,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Meaning and definition",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
              ),
              Text(
                capitalizeString(
                    'Meaning: ${widget.kanjiFromApi.englishMeaning}'),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
              ),
              Text("Kunyomi: ${widget.kanjiFromApi.hiraganaMeaning}"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
              ),
              Text("Kunyomi: ${widget.kanjiFromApi.katakanaMeaning}"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 4,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Examples",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...getIndexedExamples(
                      widget.kanjiFromApi.example, stopAnimation)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ExamplesAndInfo extends StatelessWidget {
  const ExamplesAndInfo(
      {super.key, required this.widget, required this.stopAnimation});

  final KanjiDetails widget;
  final void Function() stopAnimation;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          for (final example in widget.kanjiFromApi.example)
            ListTile(
              title: Column(
                children: [
                  Text(example.japanese),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(example.meaning.english),
                  const SizedBox(
                    height: 7,
                  ),
                ],
              ),
              trailing: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                  color: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () async {
                    stopAnimation();

                    final assetsAudioPlayer = AssetsAudioPlayer();

                    try {
                      await assetsAudioPlayer.open(
                        Audio.network(example.audio.mp3),
                      );
                    } catch (t) {
                      //mp3 unreachable
                    }
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                ),
              ),
            )
        ]),
      ),
    );
  }
}
