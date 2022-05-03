import 'dart:async';

import 'package:driverapp/bloc/user/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/screens/cancel_reason.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';

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

Timer? timer;
late Function disableCreateTripButton;
late Function updateEsimatedCost;
DateTime? startingTime;
double currentPrice = 75;
