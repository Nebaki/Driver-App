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

late Timer timer;
int waitingTimer = 40;
const oneSec = Duration(seconds: 1);
void startTimer() {
  timer = Timer.periodic(
    oneSec,
    (Timer timer) {
      print("Timer starteddd");

      // if (waitingTimer == 0) {
      //   if (nextDrivers.isNotEmpty) {
      //     UserEvent event = UserLoadById(nextDrivers[0]);
      //     BlocProvider.of<UserBloc>(context).add(event);
      //   } else {
      //     Navigator.pushNamed(context, CancelReason.routeName,
      //         arguments: CancelReasonArgument(sendRequest: true));
      //   }
      //   print("Yeah right now on action");
      //   timer.cancel();
      // } else {
      //   waitingTimer--;
      // }
    },
  );
}

void stopTimer() {
  timer.cancel();
}
