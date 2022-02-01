import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WaitingPassenger extends StatelessWidget {
  Function? callback;
  WaitingPassenger(this.callback);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
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
            Padding(
              padding: const EdgeInsets.only(bottom: 15, top: 10),
              child: RiderDetail(),
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
                      callback!(CompleteTrip(callback));
                    },
                    child: Text(
                      "Start",
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        ),
      ),
    );
  }
}
