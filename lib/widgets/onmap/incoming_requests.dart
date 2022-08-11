import 'package:flutter/material.dart';

class IncomingRequest extends StatelessWidget {
  final Function? callback;
  const IncomingRequest(this.callback, {Key? key}) : super(key: key);
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
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  // callback!(TapToAccept(callback));
                },
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 0.5),
                        borderRadius: BorderRadius.circular(100)),
                    child: const Text(
                      "Stop",
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    )),
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
                      "3 New Orders",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.red,
                  height: 0,
                ),
                Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black26.withOpacity(0.05),
                  child: const Center(
                    child: Text(
                      "Please Accept or decline orders",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
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
