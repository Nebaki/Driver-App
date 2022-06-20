import 'package:driverapp/screens/credit/credit_form.dart';
import 'package:driverapp/screens/credit/transfer_form.dart';
import 'package:driverapp/screens/history/trip_detail.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'models/models.dart';
import 'models/trip/trip.dart';

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
      ResetPasswordArgument argumet = settings.arguments as ResetPasswordArgument;
      return MaterialPageRoute(builder: (context) => ResetPassword(
        arg: argumet,
      ));
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
    if (settings.name == TeleBirrData.routeName) {
      return MaterialPageRoute(builder: (context) => TeleBirrData());
    }

    if (settings.name == TransferMoney.routeName) {
      TransferCreditArgument argument = settings.arguments as TransferCreditArgument;
      return MaterialPageRoute(builder: (context) => TransferMoney(
        balance: argument,
      ));
    }
    if (settings.name == TripDetail.routeName) {
      TripDetailArgs argument = settings.arguments as TripDetailArgs;
      return MaterialPageRoute(builder: (context) => TripDetail(
        args: argument,
      ));
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
    if (settings.name == LocationChanger.routName) {
      LocationChangerArgument argument =
          settings.arguments as LocationChangerArgument;
      return MaterialPageRoute(
          builder: (context) => LocationChanger(
                args: argument,
              ));
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

class TransferCreditArgument {
  String balance;
  TransferCreditArgument({required this.balance});
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
class LocationChangerArgument {
  final String droppOffLocationAddressName;
  final String pickupLocationAddressName;
  final LatLng pickupLocationLatLng;
  final LatLng droppOffLocationLatLng;
  final String fromWhere;

  LocationChangerArgument({
    required this.droppOffLocationAddressName,
    required this.droppOffLocationLatLng,
    required this.pickupLocationAddressName,
    required this.pickupLocationLatLng,
    required this.fromWhere,
  });

}
class TripDetailArgs{
  final Trip trip;
  TripDetailArgs({required this.trip});
}