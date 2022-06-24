import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TapToAccept extends StatelessWidget {
  final Function? callback;
  const TapToAccept(this.callback, {Key? key}) : super(key: key);
  final _locationStyle = const TextStyle(
    color: Colors.grey,
    fontSize: 16,
  );
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
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
            RiderDetail(text: 'Picking up'),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "\$12.50",
                    style: _price,
                  ),
                  Text(
                    "4.5 km",
                    style: _price,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.blue),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Bole Airport, Addis Ababa",
                    style: _locationStyle,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.green),
                  const SizedBox(
                    width: 8,
                  ),
                  Text("Meslkel Flower, Addis Ababa,", style: _locationStyle)
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 65,
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: ElevatedButton(
                    onPressed: () {
                      // callback!(Arrived(callback));
                    },
                    child: const Text(
                      "Tap To Accept",
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        ),
      ),
    );
  }

  final _price =
      const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16);
}
