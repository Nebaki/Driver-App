import 'package:flutter/material.dart';

class ShowToast{
  BuildContext context;
  String message;
  ShowToast(this.context,this.message);
  void show(){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
class ShowMessage{
  BuildContext context;
  String title;
  String message;
  ShowMessage(this.context,this.title,this.message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          // To display the title it is optional
          content: Text(message,style: const TextStyle(
            fontWeight: FontWeight.bold,color: Colors.black
          ),),
          // Message which will be pop up on the screen
          // Action widget which will provide the user to acknowledge the choice
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

}