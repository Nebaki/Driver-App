import 'package:driverapp/widgets/onlinnemode.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class OfflineMode extends StatelessWidget {
  Function? callback;
  OfflineMode(this.callback);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  callback!(OnlinMode(callback));
                },
                child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: BorderRadius.circular(100)),
                    child: Text("Go")),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      color: Colors.grey,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 2)
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: const Center(
                    child: Text(
                      "You're Offline",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                Container(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _items(
                          num: "95.0%",
                          text: "Acceptance",
                          icon: Icons.ac_unit),
                      VerticalDivider(
                        color: Colors.grey.shade300,
                      ),
                      _items(num: "4.75", text: "Rating", icon: Icons.star),
                      VerticalDivider(
                        color: Colors.grey.shade300,
                      ),
                      _items(
                          num: "2.0%", text: "Cancellation", icon: Icons.clear),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _items(
      {required String num, required String text, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: EdgeInsets.all(5),
              color: Colors.red,
              child: Icon(
                icon,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
          Text(
            num,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            text,
            style: TextStyle(
                color: Colors.black38,
                fontSize: 16,
                fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }
}
