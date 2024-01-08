import 'package:flutter/material.dart';

class ProcessProgress extends StatelessWidget {
  const ProcessProgress({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
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
      ),
    );
  }
}
