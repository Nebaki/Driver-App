import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final _textStyle = TextStyle(fontSize: 20);

  static const routeName = "/history";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Trips",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        children: List.generate(
            10, (index) => _savedItems(context: context, text: "Mon, 18 Feb")),
      ),
    );
  }

  Widget _savedItems({
    required BuildContext context,
    required String text,
  }) {
    const color = Colors.grey;
    const hoverColor = Colors.white70;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          trailing: Text(
            "\$40",
            style: _textStyle,
          ),
          //leading: Icon(Icons.history, color: color.shade700),
          title: Text(text, style: _textStyle),
          subtitle: Text(
            "25 Trips",
          ),
          hoverColor: hoverColor,
          onLongPress: () {},
          onTap: () {
            //Navigator.pushNamed(context, routename);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Divider(color: Colors.grey.shade400),
        )
      ],
    );
  }
}
