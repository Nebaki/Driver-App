import 'package:driverapp/helper/constants.dart';

class CreditEndPoints {
  static String getMyBalanceEndpoint() {
    return '$baseUrl/credits/get-my-credit';
  }
}

class UserEndPoints {
  static String middle = 'drivers';
  static String createDriverEndPoint() {
    return '$baseUrl/$middle/create-driver';
  }

  static String uploadImageEndPoint() {
    return '$baseUrl/$middle/update-profile-image';
  }

  static String deleteDriverEndPoint() {
    return '$baseUrl/$middle/delete-driver';
  }

  static String updateDriverEndPoint() {
    return '$baseUrl/$middle/update-profile';
  }

  static String updatePreferenceEndPoint() {
    return '$baseUrl/$middle/update-profile';
  }

  static String changePassewordEndPoint() {
    return '$baseUrl/$middle/change-password';
  }

  static String checkPhonenumberEndPoint(String phoneNumber) {
    return '$baseUrl/$middle/check-phone-number?phone_number=$phoneNumber';
  }

  static String forgetPasswordEndPoint() {
    return '$baseUrl/$middle/forget-password';
  }
}

class RideRequestEndPoints {
  static String middle = "ride-requests";
  static String checkDriverStartedTripEndPoint() {
    return '$baseUrl/$middle/check-driver-started-trip';
  }

  static String createManualRideRequestEndPoint() {
    return '$baseUrl/$middle/create-manual-ride-request';
  }

  static String acceptRideRequestEndPoint(String id) {
    return '$baseUrl/$middle/accept-ride-request/$id';
  }

  static String startTripEndPoint(String id) {
    return '$baseUrl/$middle/start-trip/$id';
  }

  static String cancelRideRequestEndPoint(String id) {
    return '$baseUrl/$middle/cancel-ride-request/$id';
  }

  static String completeTripEndPoint(String id) {
    return '$baseUrl/$middle/end-trip/$id';
  }
}
