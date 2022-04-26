import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driverapp/bloc/riderequest/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

bool? isDriverOnline;
late StreamSubscription<Position> homeScreenStreamSubscription;
late StreamSubscription driverStreamSubscription;

late String firebaseKey;
late String myId;
late String myPictureUrl;
late String myName;
late String myVehicleCategory;
late double myAvgRate;
String? passengerName;
late String passengerPhoneNumber;
late String requestId;
String? passengerFcm;
late LatLng droppOffPosition;
late String droppOffAddress;
late String pickUpAddress;
late LatLng pickupLocation;
late LatLng droppOffLocation;
late String distance;
late String duration;
late String price;
String? passengerProfilePictureUrl;
final player = AssetsAudioPlayer();

bool willScreenPop = true;
late Function setWillScreenPop;
late Function changeDestination;

List<String> drivers = [];
// late Timer _timer;

// int waitingTimer = 60;

// void startTimer() {
//   const oneSec = Duration(seconds: 1);
//   _timer = Timer.periodic(
//     oneSec,
//     (Timer timer) {
//       print("Timer starteddd");

//       if (timer == 0) {
//         print("Yeah right now on action");

//         // pla/yer.dispose();
//         // UserEvent event = UserLoadById(myId);
//         // BlocProvider.of<UserBloc>(context).add(event);

//         // RideRequestEvent requestEvent =
//         //     RideRequestChangeStatus(requestId, "Cancelled", passengerFcm);
//         // BlocProvider.of<RideRequestBloc>(context).add(requestEvent);
//         timer.cancel();
//       } else {
//         waitingTimer--;
//       }
//     },
//   );
// }

// late Function dialog;

// void stopTimer() {
//   _timer.cancel();
// }

String portName = 'DRIVER_BACKGROUND_lISTENER_PORT';
const maintenanceUrl = 'https://mobiletaxi-api.herokuapp.com/api';
