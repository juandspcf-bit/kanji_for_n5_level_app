import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:video_player/video_player.dart';

class KanjiDetails extends StatefulWidget {
  const KanjiDetails({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  @override
  State<KanjiDetails> createState() => KanjiDetailsState();
}

class KanjiDetailsState extends State<KanjiDetails> {
  late VideoPlayerController _controller;
  final assetsAudioPlayer = AssetsAudioPlayer();

  String capitalizeString(String text) {
    var firstLetter = text[0];
    firstLetter = firstLetter.toUpperCase();
    return firstLetter + text.substring(1);
  }

  List<Widget> getListStrokes(List<String> images) {
    List<Widget> strokes = [];
    for (int i = 0; i < images.length; i++) {
      Widget stroke = Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          Container(
            color: Colors.white70,
            height: 80,
            width: 80,
            child: SvgPicture.network(
              images[i],
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
          i != images.length - 1
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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.kanjiFromApi.videoLink))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kanjiFromApi.kanjiCharacter),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _controller.value.isInitialized
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 128 * _controller.value.aspectRatio,
                      width: 128,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 128 * _controller.value.aspectRatio,
                        width: 128,
                        child: const Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(),
                        )),
                  ],
                ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [...getListStrokes(widget.kanjiFromApi.strokes.images)],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            capitalizeString(widget.kanjiFromApi.englishMeaning),
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
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
            height: 20,
          ),
          ExamplesAndInfo(widget: widget),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

class ExamplesAndInfo extends StatelessWidget {
  const ExamplesAndInfo({
    super.key,
    required this.widget,
  });

  final KanjiDetails widget;
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
