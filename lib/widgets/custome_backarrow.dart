import 'package:flutter/material.dart';

class CustomeBackArrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 10),
      child: SizedBox(
        height: 30,
        width: 30,
        child: TextButton(
          //padding: EdgeInsets.zero,
          //color: Colors.white,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
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
