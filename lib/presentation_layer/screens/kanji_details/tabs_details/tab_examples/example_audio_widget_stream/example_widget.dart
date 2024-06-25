import 'package:flutter/material.dart';

class DummyButtonAudioExample extends StatelessWidget {
  final double sizeOval;
  final double sizeIcon;

  final int trackPlaylist;
  final int indexPlaylist;
  final bool isInPlaylistPlaying;

  const DummyButtonAudioExample({
    super.key,
    required this.sizeOval,
    required this.sizeIcon,
    required this.trackPlaylist,
    required this.indexPlaylist,
    required this.isInPlaylistPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeOval,
      height: sizeOval,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(sizeOval),
      ),
      child: trackPlaylist == indexPlaylist && isInPlaylistPlaying
          ? Icon(
              Icons.music_note,
              size: sizeIcon,
              color: Theme.of(context).colorScheme.onPrimary,
            )
          : Icon(
              Icons.play_arrow,
              size: sizeIcon,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
    );
  }
}
