import 'dart:convert';

import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/notifications/notification_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  Future initialize(
      context, callback, setDestination, setIsArrivedWidget) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print("Notification data is ::");
      print(message.data);

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
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return NotificationDialog(
                callback, setDestination, setIsArrivedWidget);
          });

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
      //         // TODO add a proper drawable resource to android, for now using
      //         //      one that already exists in example app.
      //         icon: 'launch_background',
      //       ),
      //     ),
      //   );
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
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
      print('A new onMessageOpenedApp event was published!');
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return NotificationDialog(
                callback, setDestination, setIsArrivedWidget);
          });
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

    print("The token is:: ");
    print(token);
  }
}
