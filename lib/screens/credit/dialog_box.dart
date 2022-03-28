import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:flutter/material.dart';



class PaymentBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      content: Image.asset("assets/icons/car.png", height: 100),
      title: const Text(
        "Continue",
      ),
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
            //startTelebirr(context);
            ShowToast(context, "Next Clicked").show();
            Navigator.pop(context);
          },
          child: const Text("Next"),
        ),
      ],
    );
  }

}
