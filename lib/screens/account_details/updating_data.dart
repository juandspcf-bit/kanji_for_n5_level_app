import 'package:flutter/material.dart';

class UpdatingData extends StatelessWidget {
  const UpdatingData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Updating data',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 25,
        ),
        const SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}
