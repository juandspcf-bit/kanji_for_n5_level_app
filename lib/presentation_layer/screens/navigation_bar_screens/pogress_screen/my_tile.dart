import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  const MyTile({
    super.key,
    required this.icon,
    required this.text,
  });

  final Widget icon;
  final Widget text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: icon),
        Expanded(flex: 5, child: text),
      ],
    );
  }
}
