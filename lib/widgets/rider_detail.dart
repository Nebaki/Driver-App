import 'package:flutter/material.dart';

class RiderDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "2 min",
              style: _textStyle,
            ),
            const SizedBox(width: 5),
            CircleAvatar(),
            const SizedBox(width: 5),
            Text(
              "0.5 mi",
              style: _textStyle,
            )
          ],
        ),
        Text(
          "Picking up Eyob Tilahun",
          style: TextStyle(color: Colors.indigo.shade900, fontSize: 16),
        ),
      ],
    );
  }

  final _textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.indigo.shade900,
  );
}
