import 'dart:async';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/screens/home/dialogs/circular_progress_indicator_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/session.dart';

void getLiveLocation() async {

  homeScreenStreamSubscription = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(distanceFilter: 20))
      .listen((event) {

    if (isDriverOnline != null) {
      Session().logSession("isDriverOnline", "not null");
      isDriverOnline!
          ? Geofire.setLocation(firebaseKey, event.latitude, event.longitude)
          : Geofire.removeLocation(firebaseKey);

      Session().logSession("isDriverOnline", isDriverOnline.toString());
      if (!isDriverOnline!) {
        homeScreenStreamSubscription!.cancel().then((value) {
        });
      }
    }else{
      Session().logSession("isDriverOnline", "null");
    }
  });
}

void showRideRequestLoadingDialog(context, contextTwo) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (contenxt2) {
        return const CircularProggressIndicatorDialog();
      });
}

Timer? timer;
late Function updateEsimatedCost;
DateTime? startingTime;
double currentPrice = 75;
late LatLng destination;
bool isOnTrip = false;
String tripId = "";
