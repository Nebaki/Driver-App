import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';

import 'models/models.dart';

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
      EditProfileArgument argumnet = settings.arguments as EditProfileArgument;
      return MaterialPageRoute(
          builder: (context) => EditProfile(
                args: argumnet,
              ));
    }
    if (settings.name == ProfileDetail.routeName) {
      return MaterialPageRoute(builder: (context) => ProfileDetail());
    }
    if (settings.name == CancelReason.routeName) {
      CancelReasonArgument argument =
          settings.arguments as CancelReasonArgument;
      return MaterialPageRoute(
          builder: (context) => CancelReason(
                arg: argument,
              ));
    }
    if (settings.name == CollectedCash.routeName) {
      CollectedCashScreenArgument argument =
          settings.arguments as CollectedCashScreenArgument;
      return MaterialPageRoute(
          builder: (context) => CollectedCash(
                args: argument,
              ));
    }
    if (settings.name == Walet.routeName) {
      return MaterialPageRoute(builder: (context) => Walet());
    }
    if (settings.name == Earning.routeName) {
      return MaterialPageRoute(builder: (context) => Earning());
    }
    if (settings.name == Summary.routeName) {
      return MaterialPageRoute(builder: (context) => Summary());
    }
    if (settings.name == PersonalDocument.routeName) {
      return MaterialPageRoute(builder: (context) => PersonalDocument());
    }
    if (settings.name == VehicleDocument.routeName) {
      return MaterialPageRoute(builder: (context) => VehicleDocument());
    }
    if (settings.name == CheckPhoneNumber.routeName) {
      return MaterialPageRoute(builder: (context) => CheckPhoneNumber());
    }
    if (settings.name == SettingScreen.routeName) {
      return MaterialPageRoute(builder: (context) => SettingScreen());
    }
    if (settings.name == HistoryPage.routeName) {
      return MaterialPageRoute(builder: (context) => HistoryPage());
    }

    if (settings.name == SigninScreen.routeName) {
      return MaterialPageRoute(builder: (context) => SigninScreen());
    }

    if (settings.name == PreferenceScreen.routeNAme) {
      PreferenceArgument argument = settings.arguments as PreferenceArgument;
      return MaterialPageRoute(
          builder: (context) => PreferenceScreen(
                args: argument,
              ));
    }
    if (settings.name == ChangePassword.routeName) {
      return MaterialPageRoute(builder: (context) => ChangePassword());
    }

    return MaterialPageRoute(builder: (context) => CustomSplashScreen());
  }
}

class VerificationArgument {
  String verificationId;
  int? resendingToken;
  String phoneNumber;
  VerificationArgument({
    required this.verificationId,
    required this.resendingToken,
    required this.phoneNumber,
  });
}

class HomeScreenArgument {
  bool isSelected = false;
  bool isOnline;
  String? encodedPts;
  HomeScreenArgument(
      {required this.isSelected, this.encodedPts, required this.isOnline});
}

class EditProfileArgument {
  Auth auth;
  EditProfileArgument({required this.auth});
}

class PreferenceArgument {
  String gender;
  double min_rate;
  String carType;

  PreferenceArgument(
      {required this.gender, required this.min_rate, required this.carType});
}

class CancelReasonArgument {
  final bool sendRequest;
  CancelReasonArgument({required this.sendRequest});
}

class CollectedCashScreenArgument {
  final String name;
  final double price;
  CollectedCashScreenArgument({required this.name, required this.price});
}

class ResetPasswordArgument {
  final String phoneNumber;
  ResetPasswordArgument({required this.phoneNumber});
}
