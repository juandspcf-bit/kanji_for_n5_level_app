import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';

class ErrorConnectionScreen extends StatelessWidget {
  const ErrorConnectionScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off,
                  color: Colors.amber,
                  size: 80,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ErrorConnectionDetailsScreen extends StatelessWidget {
  const ErrorConnectionDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final message = context.l10n.erroConnectionDetailsMessage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off,
                  color: Colors.amber,
                  size: 80,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
