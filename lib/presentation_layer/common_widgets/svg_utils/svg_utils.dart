import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/svg_utils/default_container.dart';

class SvgNetwork extends StatelessWidget {
  const SvgNetwork({
    super.key,
    required this.imageUrl,
    required this.semanticsLabel,
    this.height,
    this.width,
    this.colorFilter,
  });

  final String imageUrl;
  final String semanticsLabel;
  final double? width;
  final double? height;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      imageUrl,
      height: height,
      width: width,
      colorFilter: colorFilter,
      semanticsLabel: semanticsLabel,
      placeholderBuilder: (BuildContext context) => const DefaultPlaceHolder(),
    );
  }
}

class SvgFile extends StatelessWidget {
  const SvgFile({
    super.key,
    required this.imagePath,
    required this.semanticsLabel,
    this.height,
    this.width,
    this.colorFilter,
  });

  final String imagePath;
  final String semanticsLabel;
  final double? width;
  final double? height;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.file(
      File(imagePath),
      height: height,
      width: width,
      colorFilter: colorFilter,
      semanticsLabel: semanticsLabel,
      placeholderBuilder: (BuildContext context) => const DefaultPlaceHolder(),
    );
  }
}
