import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

bool? isDriverOnline;
late StreamSubscription<Position> homeScreenStreamSubscription;
late StreamSubscription driverStreamSubscription;

late String myId;
late String myPictureUrl;
late String myName;
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
late String passengerProfilePictureUrl;
final player = AssetsAudioPlayer();

bool willScreenPop = true;
late Function setWillScreenPop;
