import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/example_audio_widget_stream/audio_example_block.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class ExampleAudioStream extends StatefulWidget {
  const ExampleAudioStream({
    super.key,
    required this.sizeOval,
    required this.sizeIcon,
    required this.statusStorage,
    required this.audioQuestion,
    required this.trackPlaylist,
    required this.indexPlaylist,
    required this.isInPlaylistPlaying,
    required this.onPrimaryColor,
  });

  final double sizeOval;
  final double sizeIcon;
  final StatusStorage statusStorage;
  final String audioQuestion;
  final int trackPlaylist;
  final int indexPlaylist;
  final bool isInPlaylistPlaying;

  final Color onPrimaryColor;

  @override
  State<ExampleAudioStream> createState() => _ExampleAudioStreamState();
}

class _ExampleAudioStreamState extends State<ExampleAudioStream> {
  late AudioExampleBlock audioExampleBlock;

  @override
  void initState() {
    super.initState();

    audioExampleBlock = AudioExampleBlock(
      statusStorage: widget.statusStorage,
      audioQuestion: widget.audioQuestion,
      sizeIcon: widget.sizeIcon,
      onPrimaryColor: widget.onPrimaryColor,
    );
  }

  @override
  void dispose() {
    audioExampleBlock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ClipOval(
          child: SizedBox(
            width: widget.sizeOval,
            height: widget.sizeOval,
            child: Material(
              color: Theme.of(context).colorScheme.primary,
              child: InkWell(
                splashColor: Colors.black38,
                onTap: () {
                  audioExampleBlock.play.add(null);
                },
                child: widget.trackPlaylist == widget.indexPlaylist &&
                        widget.isInPlaylistPlaying
                    ? Icon(
                        Icons.music_note,
                        size: widget.sizeIcon,
                        color: widget.onPrimaryColor,
                      )
                    : StreamBuilder<Widget>(
                        stream: audioExampleBlock.statusIcon,
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data ??
                                Icon(
                                  Icons.play_arrow,
                                  size: widget.sizeIcon,
                                  color: widget.onPrimaryColor,
                                );
                          } else {
                            return Icon(
                              Icons.play_arrow,
                              size: widget.sizeIcon,
                              color: widget.onPrimaryColor,
                            );
                          }
                        }),
              ),
            ),
          ),
        );
      },
    );
  }
}
