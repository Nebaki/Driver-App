import 'dart:convert';
import '../providers.dart';
import 'package:driverapp/helper/api_end_points.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/screens/home/assistant/home_assistant.dart';
import 'package:driverapp/utils/session.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/helper/api_end_points.dart' as api;
import 'package:driverapp/models/models.dart';

class RideRequestDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/ride-requests';

  final _maintenanceUrl =
      'https://mobiletaxi-api.herokuapp.com/api/ride-requests';
  final _fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  /*final token =
      "AAAAKTCNpPU:APA91bHPscWDa8pPO5MGRj11FWo6NZkpK5tRPodi_2wuMdHhDNwlTO3l4jF50tFGiU55EWMyNss0St0l_kk2H1YmKH1z4yzWPVL25xGTt-GqOFWUdh7BgjJmiNo55eVzzJgHeEOBvHtH";
  */
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  RideRequestDataProvider({required this.httpClient});
  Future<RideRequest> checkStartedTrip() async {
    final http.Response response = await http.get(
        Uri.parse(RideRequestEndPoints.checkDriverStartedTripEndPoint()),
        headers: <String, String>{
          'Content-Type': "application/json",
          'x-access-token': '${await authDataProvider.getToken()}'
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['isEmpty'] != true
          ? RideRequest.fromJson(data['ride_Request'])
          : const RideRequest(
              pickUpAddress: null,
              droppOffAddress: null,
            );
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return checkStartedTrip();
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<RideRequest>> getWeeklyRideRequests() async {
    DateTime today = DateTime.now();
    DateTime weekDay = today.subtract(Duration(days: today.weekday - 1));
    final http.Response response = await http.get(
        Uri.parse(api.RideRequestEndPoints.getWeeklyRideRequestsEndPoint(
            weekDay, today)),
        headers: <String, String>{
          'Content-Type': "application/json",
          'x-access-token': '${await authDataProvider.getToken()}'
        });

    if (response.statusCode == 200) {

      final data = json.decode(response.body)['items'] as List;
      return data.isNotEmpty
          ? data.map((e) => RideRequest.fromJson(e)).toList()
          : [];
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return getWeeklyRideRequests();
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<RideRequest> createRequest(RideRequest request) async {
    final response = await http.post(
      Uri.parse(RideRequestEndPoints.createManualRideRequestEndPoint()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": '${await authDataProvider.getToken()}'
      },
      body: json.encode({
        'phone_number': request.phoneNumber,
        'name': 'request.name',
        "pickup_address": request.pickUpAddress,
        'drop_off_location': [
          request.dropOffLocation!.latitude,
          request.dropOffLocation!.longitude
        ],
        "drop_off_address": request.droppOffAddress,
        'pickup_location': [
          request.pickupLocation!.latitude,
          request.pickupLocation!.longitude
        ],
        'duration': request.duration,
        'direction': request.direction,
        'price': double.parse(request.price!),
        'status': "Accepted",
        'distance': double.parse(request.distance!)
      }),
    );

    Session().logSession("createRequest", response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      requestId = data['rideRequest']['id'];
      return RideRequest.fromJson(data['rideRequest']);
    } else {
      throw Exception('Failed to create request.');
    }
  }

  Future<void> deleteRequest(String id) async {
    final http.Response response = await httpClient.delete(
        Uri.parse('$_baseUrl/delete-request/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: {});

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user.');
    }
  }

  Future<void> changeRequestStatus(
      String id, String status, String? passengerFcm) async {
    final response =
        await http.post(Uri.parse('$_baseUrl/set-ride-request-status/$id'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              "x-access-token": '${await authDataProvider.getToken()}'
            },
            body: json.encode({'status': status}));

    if (response.statusCode == 200) {
      if (passengerFcm != null) {
        if (status == "Cancelled" ||
            status == "Arrived" ||
            status == "Completed") {
          sendNotification(passengerFcm, status);
        }
      }
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return changeRequestStatus(id, status, passengerFcm);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception('Failed to respond to the request.');
    }
  }

  Future<void> acceptRequest(String id, String passengerFcm) async {
    final response = await http.post(
      Uri.parse(RideRequestEndPoints.acceptRideRequestEndPoint(id)),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": '${await authDataProvider.getToken()}'
      },
    );

    if (response.statusCode == 200) {
      sendNotification(passengerFcm, "Accepted");
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return acceptRequest(id, passengerFcm);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception('Failed to respond to the request.');
    }
  }

  Future<void> startTrip(String id, String? passengerFcm) async {
    final response = await http.post(
      Uri.parse(RideRequestEndPoints.startTripEndPoint(id)),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": '${await authDataProvider.getToken()}'
      },
    );

    if (response.statusCode == 200) {
      if (passengerFcm != null) {
        startedNotification(passengerFcm);
      }
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return startTrip(id, passengerFcm);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw Exception('Failed to respond to the request.');
    }
  }

  Future startedNotification(String fcmToken) async {
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${await authDataProvider.getFCMToken()}'
      },
      body: json.encode({
        "data": {'response': 'Started'},
        "to": fcmToken,
        "notification": {
          "title": "Trip Started",
          "body": "Your trip has Started."
        }
      }),
    );

    if (response.statusCode == 200) {
      // final data = (response.body);
    } else {
      throw Exception('Failed to send notification.');
    }
  }

  Future sendNotification(String fcmToken, String status) async {
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${await authDataProvider.getFCMToken()}'
      },
      body: json.encode({
        "data": {'response': status, 'myId': myId},
        "to": fcmToken,
        //request.driverToken,
        // "dIZJlO16S6aIiFoGPAg9qf:APA91bHjrxQ0I5vRqyrBFHqbYBM90rYZfmb2llmtA6q8Ps6LmIS9WwoO3ENnBGUDaax7l1eTpzh71RK9YS4fyDdPdowyalVhZXbjWxq337ZEtDvOSGihA5pyuTJeS0dqQl0I9H5MfnFp",
        "notification": {
          "title": "Request Accepted",
          "body":
              "Your order request has been accepted. The provider will contact you."
        }
      }),
    );

    if (response.statusCode == 200) {
      // final data = (response.body);
      //return NotificationRequest.fromJson(data);
    } else {
      throw Exception('Failed to send notification.');
    }
  }

  Future cancelNotification(String fcmId) async {
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${await authDataProvider.getFCMToken()}'
      },
      body: json.encode({
        "data": {'response': 'Cancelled'},
        "to": fcmId,
        "notification": {
          "title": "Request Cancelled",
          "body": "Your order request has been Cancelled."
        }
      }),
    );

    if (response.statusCode == 200) {
      // final data = (response.body);
    } else {
      throw Exception('Failed to send notification.');
    }
  }

  Future cancelRideRequest(
      String id, String cancelReason, String? fcmId, bool sendRequest) async {
    final http.Response response = await http.post(
        Uri.parse(RideRequestEndPoints.cancelRideRequestEndPoint(id)),
        headers: <String, String>{
          "Content-Type": "application/json",
          "x-access-token": "${await authDataProvider.getToken()}"
        },
        body: json.encode({'cancel_reason': cancelReason}));

    if (response.statusCode == 200) {
      if (sendRequest && fcmId != null) {
        cancelNotification(fcmId);
      }
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return cancelRideRequest(id, cancelReason, fcmId, sendRequest);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw 'Unable to cancel the request';
    }
  }

  Future completeTrip(String id, double price, String? fcmId) async {
    final http.Response response = await http.post(
        Uri.parse(RideRequestEndPoints.completeTripEndPoint(id)),
        headers: <String, String>{
          "Content-Type": "application/json",
          "x-access-token": "${await authDataProvider.getToken()}"
        },
        body: json.encode({'price': currentPrice}));

    if (response.statusCode == 200) {
      if (fcmId != null) {
        completeNotification(fcmId);
      }
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return completeTrip(id, price, fcmId);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      Session().logSession("RideRequestOperationFailure",
          'trip id: $id, fcm id: $fcmId, price: $price');
      Session().logSession("RideRequestOperationFailure", response.body);
      throw 'Unable to cancel the request';
    }
  }

  Future completeNotification(String fcmId) async {
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${await authDataProvider.getFCMToken()}'
      },
      body: json.encode({
        "data": {'response': 'Completed', 'price': currentPrice},
        "to": fcmId,
        "notification": {
          "title": "Trip Completed",
          "body": "Your trip has been completed"
        }
      }),
    );

    if (response.statusCode == 200) {
      // final data = (response.body);
    } else {
      throw Exception('Failed to send notification.');
    }
  }

  Future passRequest(String driverFcm, List<dynamic> nextDrivers) async {
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${await authDataProvider.getFCMToken()}'
      },
      body: json.encode({
        "data": {
          "nextDrivers": nextDrivers,
          "response": "Searching",
          "requestId": requestId,
          "passengerFcm": passengerFcm,
          "pickupLocation": [pickupLocation.latitude, pickupLocation.longitude],
          "droppOffLocation": [
            droppOffLocation.latitude,
            droppOffLocation.longitude
          ],
          "passengerName": passengerName,
          "pickupAddress": pickUpAddress,
          "droppOffAddress": droppOffAddress,
          "passengerPhoneNumber": passengerPhoneNumber,
          "price": price,
          "duration": duration,
          "distance": distance,
          "profilePictureUrl": "someurl"
        },
        "android": {"priority": "high"},
        "to": driverFcm,
        "notification": {
          "title": "New Order Request",
          "body":
              "You have new order request open it by tapping the notification."
        }
      }),
    );
// 622ef747b9eb9b904c5d2210

    // dxGQlHGETnWjGYmlVy8Utn:APA91bErJaqPmsqfQOcStX6MYcBxfIAMr9kofXqF7bOBhftlZ3qo327e3PQ1jinm6o7FmtTy1LX4e0SE-dCUc2NwcyL6OJqKW7dagp6uTs8k-m6ynhp7NBotpPMaioTNxBuJFPz_RUif

    if (response.statusCode == 200) {
      // final data = (response.body);
      //return NotificationRequest.fromJson(data);
    } else {
      throw Exception('Failed to send notification.');
    }
  }

  Future timoutRequest(String id) async {
    final http.Response response = await http.post(
        Uri.parse('$_maintenanceUrl/timeout-ride-request/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "x-access-token": "${await authDataProvider.getToken()}"
        });
    if (response.statusCode == 200) {
      timeOutNotification('fcmId');
    } else if (response.statusCode == 401) {
      final res = await AuthDataProvider(httpClient: httpClient).refreshToken();

      if (res.statusCode == 200) {
        return timoutRequest(id);
      } else {
        throw Exception(response.statusCode);
      }
    } else {
      throw 'Unable to time out the request';
    }
  }

  Future timeOutNotification(String fcmId) async {
    await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${await authDataProvider.getFCMToken()}'
      },
      body: json.encode({
        "data": {'response': 'TimeOut'},
        "to": passengerFcm,
        "notification": {
          "title": "Request TimeOut",
          "body": "Order request timeout."
        }
      }),
    );
  }
}
