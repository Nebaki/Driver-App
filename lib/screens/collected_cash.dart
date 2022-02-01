import 'package:flutter/material.dart';

class CollectedCash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: const [
                Text(
                  "154.75",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                ),
                Text(
                  "Collected cash from Eyob Tilahun",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                ),
                Divider(),
                InkWell(
                    child: Text(
                  "Forgot Password",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                )),
              ],
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text("Done"))
        ],
      ),
    );
  }
}
