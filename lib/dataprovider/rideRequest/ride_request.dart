import 'dart:convert';
import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';

class RideRequestDataProvider {
  final _baseUrl = 'https://safeway-api.herokuapp.com/api/ride-requests';
  final _fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final token =
      "AAAAKTCNpPU:APA91bHPscWDa8pPO5MGRj11FWo6NZkpK5tRPodi_2wuMdHhDNwlTO3l4jF50tFGiU55EWMyNss0St0l_kk2H1YmKH1z4yzWPVL25xGTt-GqOFWUdh7BgjJmiNo55eVzzJgHeEOBvHtH";
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  RideRequestDataProvider({required this.httpClient});

  Future<RideRequest> createRequest(RideRequest request) async {
    // bool isPhoneNumberValid;
    // final http.Response res =
    //     await http.get(Uri.parse("$_baseUrl/check-phone-number?+2519345402"));
    // if (res.statusCode == 200) {
    //   final data = json.decode(res.body);
    //   if(data['userExit']){

    //   }
    //   else {

    //   }
    // } else {
    //   isPhoneNumberValid = false;
    // }
    final response = await http.post(
      Uri.parse('$_baseUrl/create-ride-request'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": '${await authDataProvider.getToken()}'
      },
      body: json.encode({
        'driver_id': myId,
        "pickup_address": "meskel flower",
        "droppoff_location": [2, 3],
        "droppoff_address": "test",
        'pickup_location': [
          request.pickupLocation!.latitude,
          request.pickupLocation!.longitude
        ],
        // 'droppoffLocation': [
        //   request.dropOffLocation!.longitude,
        //   request.dropOffLocation!.latitude
        // ],
      }),
    );
    print(
        ' this is the response Status coed: ${response.body} ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      requestId = data['rideRequest']['id'];
      return RideRequest.fromJson(data);
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
    print("we Are hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee!!!!!!!!!!!!!!");
    print(id);
    final res =
        await http.get(Uri.parse("https://safeway-api.herokuapp.com/api"));
    print(' the response body ${res.body}');

    // final response = await http.get(Uri.parse("$_baseUrl/get-rideRequest"));
    final response =
        await http.post(Uri.parse('$_baseUrl/set-ride-request-status/$id'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              "x-access-token": '${await authDataProvider.getToken()}'
            },
            body: json.encode({'status': status}));

    print("this is the status code: ${response.statusCode}");
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
    print("we Are hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee!!!!!!!!!!!!!!");
    print(id);

    // final response = await http.get(Uri.parse("$_baseUrl/get-rideRequest"));
    final response = await http.post(
      Uri.parse('$_baseUrl/accept-ride-request/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": '${await authDataProvider.getToken()}'
      },
    );

    print(
        "this is the status code: ${response.statusCode}  and ${response.body}");
    if (response.statusCode == 200) {
      sendNotification(passengerFcm, "Accepted");
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
        "data": {'response': status},
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

    print(response.statusCode);

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

    print(response.statusCode);

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

    print("response ${response.statusCode} ${response.body}");

    if (response.statusCode == 200) {
      if (sendRequest) {
        cancelNotification(fcmId!);
      }
    } else {
      throw 'Unable to cancel the request';
    }
  }
}
