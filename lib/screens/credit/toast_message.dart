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
class CreditAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Colors.red;
  final String title;
  final AppBar appBar;
  final List<Widget> widgets;

  /// you can add more fields that meet your needs

  const CreditAppBar({required Key key,
    required this.title,
    required this.appBar,
    required this.widgets})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.deepOrangeAccent,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
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
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.deepOrange,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
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