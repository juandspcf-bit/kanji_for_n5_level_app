import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/svg_utils/default_container.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/svg_utils/svg_utils.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class StrokesImages extends ConsumerWidget {
  final KanjiFromApi kanjiFromApi;

  const StrokesImages(
      {super.key, required this.kanjiFromApi, required this.statusStorage});

  final StatusStorage statusStorage;

  Widget _dialog(BuildContext context, String image, int index) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text("${context.l10n.stroke} ${context.l10n.number} ${index + 1}"),
      content: statusStorage == StatusStorage.onlyOnline
          ? CustomPaint(
              painter: ShapePainter(),
              child: SvgNetwork(
                imageUrl: image,
                semanticsLabel: kanjiFromApi.kanjiCharacter,
                height: MediaQuery.sizeOf(context).width * 0.4,
                width: MediaQuery.sizeOf(context).width * 0.4,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onPrimaryContainer,
                    BlendMode.srcIn),
              ),
            )
          : SvgFile(
              imagePath: image,
              height: MediaQuery.sizeOf(context).width * 0.4,
              width: MediaQuery.sizeOf(context).width * 0.4,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              semanticsLabel: kanjiFromApi.kanjiCharacter,
            ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"))
      ],
    );
  }

  void _scaleDialogForShowingSingleStroke(
      BuildContext context, String image, int index) {
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

  List<Widget> getListStrokes(BuildContext context, int containerSize) {
    final List<String> images = kanjiFromApi.strokes.images;
    List<Widget> strokes = [];
    for (int index = 0; index < images.length; index++) {
      Widget stroke = Column(
        children: [
          Container(
            height: containerSize.toDouble(),
            width: containerSize.toDouble(),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                _scaleDialogForShowingSingleStroke(
                    context, images[index], index);
              },
              child: statusStorage == StatusStorage.onlyOnline
                  ? SvgNetwork(
                      imageUrl: images[index],
                      semanticsLabel: kanjiFromApi.kanjiCharacter,
                    )
                  : SvgFile(
                      imagePath: images[index],
                      semanticsLabel: kanjiFromApi.kanjiCharacter,
                    ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
              '${context.l10n.ordinal_numbers((index + 1).toString())} ${context.l10n.stroke}')
        ],
      );
      strokes.add(stroke);
    }
    return strokes;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final sizeScreen = getScreenSizeWidth(context);
    int crossAxisCount;
    int containerSize;
    switch ((orientation, sizeScreen)) {
      case (Orientation.landscape, _):
        {
          crossAxisCount = 4;
          containerSize = 80;
        }
      case (_, ScreenSizeWidth.extraLarge):
        {
          crossAxisCount = 6;
          containerSize = 140;
        }
      case (_, ScreenSizeWidth.large):
        {
          crossAxisCount = 4;
          containerSize = 100;
        }
      case (_, _):
        {
          crossAxisCount = 3;
          containerSize = 80;
        }
    }
    return Column(
      children: [
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
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: GridView(
            padding: const EdgeInsets.all(5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            children: [...getListStrokes(context, containerSize)],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
