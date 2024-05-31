import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      placeholderBuilder: (BuildContext context) => Container(
        margin: const EdgeInsets.all(5),
        color: Colors.transparent,
        child: const CircularProgressIndicator(
          backgroundColor: Color.fromARGB(179, 5, 16, 51),
        ),
      ),
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
      placeholderBuilder: (BuildContext context) => Container(
        margin: const EdgeInsets.all(5),
        color: Colors.transparent,
        child: const CircularProgressIndicator(
          backgroundColor: Color.fromARGB(179, 5, 16, 51),
        ),
      ),
    );
  }
}
