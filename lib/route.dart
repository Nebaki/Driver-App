import 'package:driverapp/screens/credit/credit_form.dart';
import 'package:driverapp/screens/credit/transfer_form.dart';
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
      return MaterialPageRoute(builder: (context) => CancelReason());
    }
    if (settings.name == CollectedCash.routeName) {
      return MaterialPageRoute(builder: (context) => CollectedCash());
    }
    if (settings.name == Walet.routeName) {
      return MaterialPageRoute(builder: (context) => Walet());
    }
    if (settings.name == TeleBirrData.routeName) {
      return MaterialPageRoute(builder: (context) => TeleBirrData());
    }
    if (settings.name == TransferMoney.routeName) {
      return MaterialPageRoute(builder: (context) => TransferMoney());
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

  VerificationArgument({required this.verificationId});
}

class HomeScreenArgument {
  bool isSelected = false;

  HomeScreenArgument({required this.isSelected});
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
