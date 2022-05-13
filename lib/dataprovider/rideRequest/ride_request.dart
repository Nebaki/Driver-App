import 'dart:convert';
import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/screens/home/assistant/home_assistant.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';

class RideRequestDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/ride-requests';

  final _maintenanceUrl =
      'https://mobiletaxi-api.herokuapp.com/api/ride-requests';
  final _fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final token =
      "AAAAKTCNpPU:APA91bHPscWDa8pPO5MGRj11FWo6NZkpK5tRPodi_2wuMdHhDNwlTO3l4jF50tFGiU55EWMyNss0St0l_kk2H1YmKH1z4yzWPVL25xGTt-GqOFWUdh7BgjJmiNo55eVzzJgHeEOBvHtH";
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  RideRequestDataProvider({required this.httpClient});
  Future<RideRequest> checkStartedTrip() async {
    final http.Response response = await http.get(
        Uri.parse(
            'https://mobiletaxi-api.herokuapp.com/api/ride-requests/check-driver-started-trip'),
        headers: <String, String>{
          'Content-Type': "application/json",
          'x-access-token': '${await authDataProvider.getToken()}'
        });
    print(' this is the response Status coed: ${response.statusCode}');
    print(' hah ${json.decode(response.body)['ride_Request']}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['isEmpty'] != true
          ? RideRequest.fromJson(data['ride_Request'])
          : RideRequest(
              pickUpAddress: null,
              droppOffAddress: null,
              driverId: null,
            );
    } else {
      throw 'Unable to get Started Trips';
    }
  }

  Future<RideRequest> createRequest(RideRequest request) async {
    final response = await http.post(
      Uri.parse('$_maintenanceUrl/create-manual-ride-request'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": '${await authDataProvider.getToken()}'
      },
      body: json.encode({
        'phone_number': request.phoneNumber,
        'name': 'request.name',
        "pickup_address": "meskel flower",
        'droppoff_location': [
          request.dropOffLocation!.longitude,
          request.dropOffLocation!.latitude
        ],
        "droppoff_address": request.droppOffAddress,
        'pickup_location': [
          request.pickupLocation!.latitude,
          request.pickupLocation!.longitude
        ],
        'duration': request.duration,
        'direction': request.direction,
        'price': int.parse(request.price!),
        'status': "Accepted",
        'distance': int.parse(request.distance!)
      }),
    );

    print("DATAAAAAAAAAAAAAAAAA status = ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("DATAAAAAAAAAAAAAAAAA ${data}");

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
    final res =
        await http.get(Uri.parse("https://safeway-api.herokuapp.com/api"));

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
    } else {
      throw Exception('Failed to respond to the request.');
    }
  }

  Future<void> acceptRequest(String id, String passengerFcm) async {
    // final response = await http.get(Uri.parse("$_baseUrl/get-rideRequest"));
    final response = await http.post(
      Uri.parse('$_maintenanceUrl/accept-ride-request/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": '${await authDataProvider.getToken()}'
      },
    );

    if (response.statusCode == 200) {
      sendNotification(passengerFcm, "Accepted");
    } else {
      throw Exception('Failed to respond to the request.');
    }
  }

  Future<void> startTrip(String id, String? passengerFcm) async {
    // final response = await http.get(Uri.parse("$_baseUrl/get-rideRequest"));
    final response = await http.post(
      Uri.parse('$_maintenanceUrl/start-trip/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": '${await authDataProvider.getToken()}'
      },
    );

    if (response.statusCode == 200) {
      // sendNotification(passengerFcm, "Accepted");
    } else {
      throw Exception('Failed to respond to the request.');
    }
  }

  Future sendNotification(String fcmToken, String status) async {
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$token'
      },
      body: json.encode({
        "data": {'response': status, 'myId': myId},
        "to": fcmToken,
        //request.driverToken,
        // "dIZJlO16S6aIiFoGPAg9qf:APA91bHjrxQ0I5vRqyrBFHqbYBM90rYZfmb2llmtA6q8Ps6LmIS9WwoO3ENnBGUDaax7l1eTpzh71RK9YS4fyDdPdowyalVhZXbjWxq337ZEtDvOSGihA5pyuTJeS0dqQl0I9H5MfnFp",
        "notification": {
          "title": "RideRequest Accepted",
          "body":
              "Your rider request has been accepted. the driver will contact you."
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = (response.body);
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
        'Authorization': 'key=$token'
      },
      body: json.encode({
        "data": {'response': 'Cancelled'},
        "to": fcmId,
        "notification": {
          "title": "RideRequest Cancelled",
          "body": "Your ride request has been Cancelled."
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = (response.body);
    } else {
      throw Exception('Failed to send notification.');
    }
  }

  Future cancelRideRequest(
      String id, String cancelReason, String? fcmId, bool sendRequest) async {
    final http.Response response =
        await http.post(Uri.parse('$_baseUrl/cancel-ride-request/$id'),
            headers: <String, String>{
              "Content-Type": "application/json",
              "x-access-token": "${await authDataProvider.getToken()}"
            },
            body: json.encode({'cancel_reason': cancelReason}));
    print("Statusss issss ${response.statusCode}', ${fcmId}, ${sendRequest}");

    if (response.statusCode == 200) {
      if (sendRequest && fcmId != null) {
        cancelNotification(fcmId);
      }
    } else {
      throw 'Unable to cancel the request';
    }
  }

  Future completeTrip(String id, double price, String? fcmId) async {
    final http.Response response =
        await http.post(Uri.parse('$_maintenanceUrl/end-trip/$id'),
            headers: <String, String>{
              "Content-Type": "application/json",
              "x-access-token": "${await authDataProvider.getToken()}"
            },
            body: json.encode({'price': currentPrice}));

    if (response.statusCode == 200) {
      print("fcm_issddddddd $fcmId");
      if (fcmId != null) {
        completeNotification(fcmId);
      }
    } else {
      throw 'Unable to cancel the request';
    }
  }

  Future completeNotification(String fcmId) async {
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$token'
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
      final data = (response.body);

      print(response.body);
    } else {
      throw Exception('Failed to send notification.');
    }
  }

  Future passRequest(String driverFcm, List<dynamic> nextDrivers) async {
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$token'
      },
      body: json.encode({
        "data": {
          "nextDrivers": nextDrivers,
          "response": "Cancelled",
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
          "title": "New RideRequest",
          "body":
              "You have new ride request open it by tapping the nottification."
        }
      }),
    );
// 622ef747b9eb9b904c5d2210

    // dxGQlHGETnWjGYmlVy8Utn:APA91bErJaqPmsqfQOcStX6MYcBxfIAMr9kofXqF7bOBhftlZ3qo327e3PQ1jinm6o7FmtTy1LX4e0SE-dCUc2NwcyL6OJqKW7dagp6uTs8k-m6ynhp7NBotpPMaioTNxBuJFPz_RUif

    print("Status code is ${response.body}");

    if (response.statusCode == 200) {
      print("come on come on turn the radio on it;s friday night");
      final data = (response.body);
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
    print('status code is ${response.statusCode}');
    if (response.statusCode == 200) {
      timeOutNotification('fcmId');
    } else {
      throw 'Unable to time out the request';
    }
  }

  Future timeOutNotification(String fcmId) async {
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$token'
      },
      body: json.encode({
        "data": {'response': 'TimeOut'},
        "to": passengerFcm,
        "notification": {
          "title": "RideRequest TimeOut",
          "body": "Ride request timeout."
        }
      }),
    );
    print('notification status code is ${response.statusCode}');
  }
}
