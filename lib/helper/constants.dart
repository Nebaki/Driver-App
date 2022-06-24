import 'dart:async';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driverapp/bloc/riderequest/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

bool? isDriverOnline;
late StreamSubscription<Position> homeScreenStreamSubscription;
late StreamSubscription<Position> driverStreamSubscription;

late String firebaseKey;
late String myId;
late String myPictureUrl;
late String myName;
late String myVehicleCategory;
late String myVehicleType;
late int initialFare;
late int costPerMinute;
late int costPerKilloMeter;
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
late double balance;
String? passengerProfilePictureUrl;
// final player = AssetsAudioPlayer();
bool isAccepted = false;
List<String> drivers = [];
String portName = 'DRIVER_BACKGROUND_lISTENER_PORT';
const maintenanceUrl = 'https://mobiletaxi-api.herokuapp.com/api';
String baseUrl = 'https://safeway-api.herokuapp.com/api';
const shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
