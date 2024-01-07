import 'package:flutter/material.dart';

class NoDataToShownScreen extends StatelessWidget {
  const NoDataToShownScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No data to show',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.data_usage,
              color: Theme.of(context).colorScheme.primary,
              size: 80,
            ),
          ],
        )
      ],
    );
  }
}
