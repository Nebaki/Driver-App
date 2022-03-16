import 'dart:convert';
import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:http/http.dart' as http;
import 'package:driverapp/models/models.dart';

class RideRequestDataProvider {
  final _baseUrl = 'http://192.168.1.9:5000/api/rideRequests';
  final _fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final token =
      "AAAAKTCNpPU:APA91bHPscWDa8pPO5MGRj11FWo6NZkpK5tRPodi_2wuMdHhDNwlTO3l4jF50tFGiU55EWMyNss0St0l_kk2H1YmKH1z4yzWPVL25xGTt-GqOFWUdh7BgjJmiNo55eVzzJgHeEOBvHtH";
  final http.Client httpClient;
  AuthDataProvider authDataProvider =
      AuthDataProvider(httpClient: http.Client());

  RideRequestDataProvider({required this.httpClient});

  Future<RideRequest> createRequest(RideRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-rideRequest'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": '${await authDataProvider.getToken()}'
      },
      body: json.encode({
        'driverId': 'waiting',
        'passengerName': request.passengerName,
        'passengerPhoneNumber': "+251987654321",
        "pickupAddress": "meskel flower",
        'pickupLocation': request.pickupLocation,
        'droppoffLocation': request.dropOffLocation,
      }),
    );
    print(' this is the response Status coed: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
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
      String id, String status, String passengerFcm) async {
    print("we Are hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee!!!!!!!!!!!!!!");
    print(id);

    // final response = await http.get(Uri.parse("$_baseUrl/get-rideRequest"));
    final response =
        await http.post(Uri.parse('$_baseUrl/set-rideRequestStatus/$id'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              "x-access-token": '${await authDataProvider.getToken()}'
            },
            body: json.encode({'status': status}));

    print("this is the status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (status == "Cancelled" || status == "Arrived") {
        sendNotification(passengerFcm, status);
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
      Uri.parse('$_baseUrl/accept-rideRequest/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "x-access-token": '${await authDataProvider.getToken()}'
      },
    );

    print("this is the status code: ${response.statusCode}");
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
}
