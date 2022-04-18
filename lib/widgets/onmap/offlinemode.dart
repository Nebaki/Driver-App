import 'dart:async';

import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OfflineMode extends StatelessWidget {
  Function? callback;
  // Function getLiveLocation;
  Function setDriverStatus;
  bool isDriverOn = false;
  OfflineMode(this.setDriverStatus, this.callback);
  void getLiveLocation() async {
    print(firebaseKey);
    homeScreenStreamSubscription = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(distanceFilter: 5))
        .listen((event) {
      if (isDriverOnline != null) {
        isDriverOnline!
            ? Geofire.setLocation(firebaseKey, event.latitude, event.longitude)
            : Geofire.removeLocation(myId);

        if (!isDriverOnline!) {
          homeScreenStreamSubscription.cancel();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isDriverOnline != null) {
      !isDriverOnline! ? Geofire.removeLocation(firebaseKey) : null;
    }
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
                  isDriverOnline = true;
                  // setDriverStatus(true);
                  getLiveLocation();
                  callback!(OnlinMode(callback, setDriverStatus));
                },
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: BorderRadius.circular(100)),
                    child: const Text("Go")),
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
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
                          num: "\$95",
                          text: "Earning",
                          icon: Icons.monetization_on),
                      VerticalDivider(
                        color: Colors.grey.shade300,
                      ),
                      _items(num: "4.75", text: "Rating", icon: Icons.star),
                      VerticalDivider(
                        color: Colors.grey.shade300,
                      ),
                      _items(
                          num: "\$342",
                          text: "Wallet",
                          icon: Icons.wallet_giftcard),
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
              padding: const EdgeInsets.all(5),
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
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            text,
            style: const TextStyle(
                color: Colors.black38,
                fontSize: 16,
                fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }
}
