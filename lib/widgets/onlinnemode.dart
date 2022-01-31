import 'package:flutter/material.dart';

class OnlinMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {},
                  child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(100)),
                      child: Text("Go")),
                ),
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
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Finding Trips",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  height: 90,
                  padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black26.withOpacity(0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Opportunity nearby",
                        style: TextStyle(color: Colors.red, fontSize: 24),
                      ),
                      Text(
                        "More requests than usual",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )
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
}
