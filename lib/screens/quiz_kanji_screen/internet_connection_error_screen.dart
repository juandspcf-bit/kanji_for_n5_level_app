import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InternetConnectionErrorScreen extends ConsumerWidget {
  const InternetConnectionErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'The internet connection has gone, restart the quiz later',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(overflow: TextOverflow.ellipsis),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.amber,
              size: 80,
            ),
          ],
        )
      ],
    );
  }
}
