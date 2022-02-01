import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == PhoneVerification.routeName) {
      VerificationArgument argument =
          settings.arguments as VerificationArgument;
      return MaterialPageRoute(
          builder: (context) => PhoneVerification(
                args: argument,
              ));
    }
    if (settings.name == HomeScreen.routeName) {
      HomeScreenArgument argument = settings.arguments as HomeScreenArgument;
      return MaterialPageRoute(
          builder: (context) => HomeScreen(
                args: argument,
              ));
    }
    if (settings.name == ResetPassword.routeName) {
      return MaterialPageRoute(builder: (context) => ResetPassword());
    }
    if (settings.name == EditProfile.routeName) {
      return MaterialPageRoute(builder: (context) => EditProfile());
    }
    if (settings.name == ProfileDetail.routeName) {
      return MaterialPageRoute(builder: (context) => ProfileDetail());
    }
    if (settings.name == CancelReason.routeName) {
      return MaterialPageRoute(builder: (context) => CancelReason());
    }
    return MaterialPageRoute(builder: (context) => const SigninScreen());
  }
}

class VerificationArgument {
  String verificationId;

  VerificationArgument({required this.verificationId});
}

class HomeScreenArgument {
  bool isSelected = false;

  HomeScreenArgument({required this.isSelected});
}
