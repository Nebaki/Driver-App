import 'package:driverapp/utils/theme/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';

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
  final TabBar? bottom;
  /// you can add more fields that meet your needs

  const CreditAppBar({required Key key,
    required this.title,
    required this.appBar,
    required this.widgets,
    this.bottom})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return AppBar(
      elevation: 0.5,
      bottom: bottom,
      backgroundColor: themeProvider.getColor,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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