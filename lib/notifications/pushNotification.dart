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

      final d = json.decode(message.data['pickupLocation']);
      final dp = json.decode(message.data['droppoffLocation']);

      print('this is d: ${d[0]}');
      LatLng passengerPosition = LatLng(d[0], d[1]);
      LatLng droppOffPosition = LatLng(dp[0], dp[1]);
      passengerName = message.data['passengerName'];
      passengerPhoneNumber = message.data['passengerPhoneNumber'];
      requestId = message.data['requestId'];
      passengerFcm = message.data['passengerFcm'];
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return NotificationDialog(
                message.data['passengerFcm'],
                message.data['requestId'],
                message.data['passengerName'],
                passengerPosition,
                message.data['pickupAddress'],
                message.data['dropOffAddress'],
                callback,
                setDestination,
                setIsArrivedWidget);
          });

      // if (notification != null && android != null && !kIsWeb) {
      //   flutterLocalNotificationsPlugin.show(
      //     notification.hashCode,
      //     notification.title,
      //     notification.body,
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
      print('A new onMessageOpenedApp event was published!');
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
