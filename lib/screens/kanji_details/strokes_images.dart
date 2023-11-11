import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class StrokesImages extends ConsumerWidget {
  final KanjiFromApi kanjiFromApi;

  const StrokesImages(
      {super.key, required this.kanjiFromApi, required this.statusStorage});

  final StatusStorage statusStorage;

  Widget _dialog(BuildContext context, String image, int index) {
    return AlertDialog(
      title: Text("Stroke number ${index + 1}"),
      content: SvgPicture.network(
        image,
        height: 120,
        width: 120,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        semanticsLabel: kanjiFromApi.kanjiCharacter,
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

  void _scaleDialog(BuildContext context, String image, int index) {
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

  List<Widget> getListStrokes(BuildContext context) {
    final List<String> images = kanjiFromApi.strokes.images;
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
                _scaleDialog(context, images[index], index);
              },
              child: statusStorage == StatusStorage.onlyOnline
                  ? SvgPicture.network(
                      images[index],
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [...getListStrokes(context)],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    ); // TODO: implement build
  }
}
