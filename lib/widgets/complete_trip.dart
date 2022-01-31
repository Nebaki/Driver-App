import 'package:flutter/material.dart';

class CompleteTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        child: Column(
          children: [
            Row(
              children: [Text("2 min"), CircleAvatar(), Text("0.5 mi")],
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 20, right: 20),
                child:
                    ElevatedButton(onPressed: () {}, child: Text("Complete")))
          ],
        ),
      ),
    );
  }
}
