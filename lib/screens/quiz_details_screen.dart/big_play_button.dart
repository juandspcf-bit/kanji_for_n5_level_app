import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BigPlayButton extends ConsumerWidget {
  const BigPlayButton({
    super.key,
    required this.sizeOval,
    required this.sizeIcon,
    required this.onTap,
  });

  final double sizeOval;
  final double sizeIcon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipOval(
      child: SizedBox(
        width: sizeOval,
        height: sizeOval,
        child: Material(
          color: Theme.of(context).colorScheme.primary,
          child: InkWell(
            splashColor: Colors.black38,
            onTap: onTap,
            child: Icon(
              Icons.play_arrow,
              size: sizeIcon,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
