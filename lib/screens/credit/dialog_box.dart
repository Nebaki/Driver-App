import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:flutter/material.dart';

class PaymentBox extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      content: Container(
        child: Image.asset("assets/icons/car.png",height: 100),
      ),
      title: const Text("Continue",),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ShowToast(context, "Cancel Clicked").show();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ShowToast(context, "Next Clicked").show();
          },
          child: const Text("Next"),
        ),
      ],
    );
  }
}