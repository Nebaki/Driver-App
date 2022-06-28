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
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      player.open(Audio("assets/sounds/announcement-sound.mp3"));

      if (message.data['response'] == 'Cancelled') {
        if (isAccepted) {
          BlocProvider.of<DirectionBloc>(context).add(
              const DirectionChangeToInitialState(
                  isBalanceSuffiecient: true, isFromOnlineMode: true));
          isAccepted = false;
        } else {
          Navigator.pop(context);
          BlocProvider.of<CurrentWidgetCubit>(context)
              .changeWidget(const OnlinMode());
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Request Cancelled"),
        ));

        // callback(OnlinMode());
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
              // player.open(Audio("assets/sounds/announcement-sound.mp3"));
              return NotificationDialog(
                  setDestination, listOfDrivers, 40, true);
            });
      } else {}

      // if (notification != null && android != null && !kIsWeb) {
      //   flutterLocalNotificationsPlugin.show(
      //     notification.hashCode,
      //     notification.title,
      //     notification.body,dxGQlHGETnWjGYmlVy8Utn:APA91bErJaqPmsqfQOcStX6MYcBxfIAMr9kofXqF7bOBhftlZ3qo327e3PQ1jinm6o7FmtTy1LX4e0SE-dCUc2NwcyL6OJqKW7dagp6uTs8k-m6ynhp7NBotpPMaioTNxBuJFPz_RUif
      //     NotificationDetails(
      //       android: AndroidNotificationDetails(
      //         channel.id,
      //         channel.name,
      //         channel.description,
      //         //      one that already exists in example app.
      //         icon: 'launch_background',
      //       ),
      //     ),
      //   );
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // final pickupList = json.decode(message.data['pickupLocation']);
      // final droppOffList = json.decode(message.data['droppOffLocation']);

      // pickupLocation = LatLng(pickupList[0], pickupList[1]);
      // droppOffLocation = LatLng(droppOffList[0], droppOffList[1]);
      // passengerName = message.data['passengerName'];
      // passengerPhoneNumber = message.data['passengerPhoneNumber'];
      // requestId = message.data['requestId'];
      // passengerFcm = message.data['passengerFcm'];
      // distance = message.data['distance'];
      // duration = message.data['duration'];
      // price = message.data['price'];
      // droppOffAddress = message.data['droppOffAddress'];
      // pickUpAddress = message.data['pickupAddress'];
      // passengerProfilePictureUrl = message.data['profilePictureUrl'];
      // final listOfDrivers = json.decode(message.data['nextDrivers']);

      // print('A new onMessageOpenedApp event was published!');
      // showDialog(
      //     barrierDismissible: false,
      //     context: context,
      //     builder: (BuildContext context) {
      //       return NotificationDialog(callback, setDestination,
      //           setIsArrivedWidget, listOfDrivers, 40, true);
      //     });
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    });
  }

  // dIZJlO16S6aIiFoGPAg9qf:APA91bGdQUwRBX7Hs7UZnGpfD3jaLZMeBbVDa-HE7z1MEyQ8o-fIA-VHZxOAnAx--y-njcuVEkbxTo0s-C1sC-TKEKPXBvWnii3BsZeCk9tXoLJfDNbydeDZ9c3VWjZHWKyTUJOzfiPm
  // dIZJlO16S6aIiFoGPAg9qf:APA91bGdQUwRBX7Hs7UZnGpfD3jaLZMeBbVDa-HE7z1MEyQ8o-fIA-VHZxOAnAx--y-njcuVEkbxTo0s-C1sC-TKEKPXBvWnii3BsZeCk9tXoLJfDNbydeDZ9c3VWjZHWKyTUJOzfiPm
  // dIZJlO16S6aIiFoGPAg9qf:APA91bHjrxQ0I5vRqyrBFHqbYBM90rYZfmb2llmtA6q8Ps6LmIS9WwoO3ENnBGUDaax7l1eTpzh71RK9YS4fyDdPdowyalVhZXbjWxq337ZEtDvOSGihA5pyuTJeS0dqQl0I9H5MfnFp
  // void showNotification(context, callback, setDestination, setIsArrivedWidget) {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return NotificationDialog(
  //             callback, setDestination, setIsArrivedWidget);
  //       });
  // }

  void seubscribeTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('driver');

    // final token = await FirebaseMessaging.instance.getToken();
    // print("The token is:: ");
    // print(token);
    //await FirebaseMessaging.instance.deleteToken();
    final token = await FirebaseMessaging.instance.getToken();

    debugPrint("The token is:: ");
    debugPrint(token);
  }
}
