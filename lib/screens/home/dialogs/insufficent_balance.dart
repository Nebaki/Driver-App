import 'package:flutter/material.dart';

class InsufficentBalanceDialog extends StatelessWidget {
  const InsufficentBalanceDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insufficent Balance'),
      content: const Text(
          'Sorry your credit balance is insufficient. you have to recharg your account in order to go online and create trip.'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Okay'))
      ],
    );
  }
}
