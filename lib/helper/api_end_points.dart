import 'package:driverapp/helper/constants.dart';

class CategoryEndPoints {
  static String getCategoriesEndPoint(String id) {
    return '$baseUrl/categories/get-category/$id';
  }
}

class CreditEndPoints {
  static String getMyBalanceEndpoint() {
    return '$baseUrl/credits/get-my-credit';
  }
}

class WeeklyEarningEndPoints {
  static String getWeeklyEarningEndPoint(DateTime from, DateTime to) {
    return '$baseUrl/ride-requests/get-my-grouped-earnings?filter[0].[field]=createdAt&filter[0].[operator]=between&filter[0].[value][0]=$from&filter[0].[value][1]=$to&filter[0].[type]=date';
  }
}
class DailyEarningEndPoints {
  static String getDailyEarningEndPoint() {
    return '$baseUrl/ride-requests/get-my-todays-earning';
  }
}


class SettingsEndPoint {
  static String getSettingsEndPoint() {
    return "$baseUrl/settings/get-setting";
  }
}

class UserEndPoints {
  static String middle = 'drivers';
  static String getMyRatingEndPoint() => '$baseUrl/drivers/get-my-rate';

  static changeStatusEndPoint(bool status) => '$baseUrl/$middle/update-status';

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

  static String getWeeklyRideRequestsEndPoint(DateTime from, DateTime to) {
    return '$baseUrl/ride-requests/get-driver-trips?filter[0].[field]=createdAt&filter[0].[operator]=between&filter[0].[value][0]=$from&filter[0].[value][1]=$to&filter[0].[type]=date';
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

class AuthEndPoints {
  static String refreshTokenEndPoint() => '$baseUrl/auth/refresh';
}
