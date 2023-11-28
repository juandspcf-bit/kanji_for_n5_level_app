import 'package:flutter/material.dart';

class FetchingData extends StatelessWidget {
  const FetchingData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Fetching data',
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
