import 'package:flutter/material.dart';

mixin StatusDBStoringDialogs {
  Widget _statusDBStoringDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Please wait!!"),
      content: const Text('Please wait until all the operations are completed'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

  void statusDBStoringDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _statusDBStoringDialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
