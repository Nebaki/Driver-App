import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'dart:convert';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/notifications/notification_dialog.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  Future initialize(context, setDestination, setDriverStatus) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      player.open(Audio("assets/sounds/announcement-sound.mp3"));
      if (message.data['response'] == 'Cancelled') {
        if (isAccepted) {
          BlocProvider.of<DirectionBloc>(context).add(
              const DirectionChangeToInitialState(
                  isBalanceSufficient: true, isFromOnlineMode: true));
          isAccepted = false;
        } else {
          Navigator.pop(context);
          BlocProvider.of<CurrentWidgetCubit>(context)
              .changeWidget(const OnlinMode());
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Request Cancelled"),
        ));
      }

      debugPrint("Notification data is ::");
      debugPrint(message.data.toString());
      if (message.data['passengerName'] != null) {
        final pickupList = json.decode(message.data['pickupLocation']);
        final droppOffList = json.decode(message.data['droppOffLocation']);
        pickupLocation = LatLng(pickupList[0], pickupList[1]);
        droppOffLocation = LatLng(droppOffList[0], droppOffList[1]);
        passengerName = message.data['passengerName'];
        passengerPhoneNumber = message.data['passengerPhoneNumber'];
        requestId = message.data['requestId'];
        passengerFcm = message.data['passengerFcm'];
        distance = message.data['distance'];
        duration = message.data['duration'];
        price = message.data['price'];
        droppOffAddress = message.data['droppOffAddress'];
        pickUpAddress = message.data['pickupAddress'];
        passengerProfilePictureUrl = message.data['profilePictureUrl'];
        final listOfDrivers = json.decode(message.data['nextDrivers']) as List;
        listOfDrivers.removeAt(0);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return NotificationDialog(
                  setDestination, listOfDrivers, 40, true);
            });
      } else {}

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

    });
  }

  void seubscribeTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('driver');

    final token = await FirebaseMessaging.instance.getToken();

    debugPrint("The token is:: ");
    debugPrint(token);
  }
}
