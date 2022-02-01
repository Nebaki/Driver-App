import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Arrived extends StatelessWidget {
  Function? callback;
  Arrived(this.callback);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
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
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: [
            RiderDetail(),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: MediaQuery.of(context).size.width,
                child: Divider()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildItems(
                    text: "Chat", icon: Icons.chat_bubble_outline_rounded),
                _buildItems(text: "Message", icon: Icons.message_outlined),
                _buildItems(text: "Cancel Trip", icon: Icons.clear_outlined)
              ],
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 65,
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.indigo.shade900),
                    onPressed: () {
                      callback!(WaitingPassenger(callback));
                    },
                    child: Text(
                      "Arrived",
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        ),
      ),
    );
  }

  Widget _buildItems({required String text, required IconData icon}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: Colors.indigo.shade900,
              size: 22,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            text,
            style: TextStyle(color: Colors.indigo.shade900),
          ),
        ),
      ],
    );
  }
}
