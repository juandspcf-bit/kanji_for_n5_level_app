import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class StrokesImages extends ConsumerWidget {
  final KanjiFromApi kanjiFromApi;

  static const _ordinals = [
    "1st",
    "2nd",
    "3rd",
    "4th",
    "5th",
    "6th",
    "7th",
    "8th",
    "9th",
    "10th",
    "11th",
    "12th",
    "13th",
    "14th",
    "15th",
    "16th",
    "17th",
    "18th",
    "19th",
    "20th",
    "21st",
    "22nd",
    "23rd",
    "24th",
  ];

  const StrokesImages(
      {super.key, required this.kanjiFromApi, required this.statusStorage});

  final StatusStorage statusStorage;

  Widget _dialog(BuildContext context, String image, int index) {
    return AlertDialog(
      title: Text("${context.l10n.stroke} ${context.l10n.number} ${index + 1}"),
      content: statusStorage == StatusStorage.onlyOnline
          ? SvgPicture.network(
              image,
              height: 120,
              width: 120,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              semanticsLabel: kanjiFromApi.kanjiCharacter,
              placeholderBuilder: (BuildContext context) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.transparent,
                    height: 80,
                    width: 80,
                    child: const CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(179, 5, 16, 51),
                    ),
                  ),
                ],
              ),
            )
          : SvgPicture.file(
              File(image),
              height: 120,
              width: 120,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              semanticsLabel: kanjiFromApi.kanjiCharacter,
              placeholderBuilder: (BuildContext context) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.transparent,
                    height: 80,
                    width: 80,
                    child: const CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(179, 5, 16, 51),
                    ),
                  ),
                ],
              ),
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
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: GestureDetector(
              onTap: () {
                _scaleDialogForShowingSingleStroke(
                    context, images[index], index);
              },
              child: statusStorage == StatusStorage.onlyOnline
                  ? SvgPicture.network(
                      images[index],
                      height: 80,
                      width: 80,
                      semanticsLabel: kanjiFromApi.kanjiCharacter,
                      placeholderBuilder: (BuildContext context) => Container(
                          margin: const EdgeInsets.all(5),
                          color: Colors.transparent,
                          height: 40,
                          width: 40,
                          child: const CircularProgressIndicator(
                            backgroundColor: Color.fromARGB(179, 5, 16, 51),
                          )),
                    )
                  : SvgPicture.file(
                      File(images[index]),
                      height: 80,
                      width: 80,
                      semanticsLabel: kanjiFromApi.kanjiCharacter,
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
          const SizedBox(
            height: 10,
          ),
          Text('${_ordinals[index]} ${context.l10n.stroke}')
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
