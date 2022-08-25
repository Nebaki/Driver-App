import 'package:flutter/material.dart';

class CustomeBackArrow extends StatelessWidget {
  const CustomeBackArrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 10),
      child: SizedBox(
        height: 30,
        width: 30,
        child: TextButton(
          onPressed: () {
            return Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
