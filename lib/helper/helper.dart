import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


Future<void> makePhoneCall(String phoneNumber) async {

  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

Future<void> sendTextMessage(String phoneNumber) async {

  final Uri launchUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

void gotoSignIn(BuildContext context) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    SigninScreen.routeName,
    ((Route<dynamic> route) => false),
  );
}
