import 'package:flutter/material.dart';

class LoginProgress extends StatelessWidget {
  const LoginProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Login to your account',
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
