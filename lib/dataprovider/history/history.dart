import 'dart:math';

import 'package:driverapp/models/trip/trip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/session.dart';
import '../database/database.dart';
import '../header/header.dart';

import 'package:http/http.dart' as http;

class HistoryDataProvider {
  final _baseUrl = RequestHeader.baseURL + 'credits';
  final http.Client httpClient;

  HistoryDataProvider({required this.httpClient});

  Future<String> loadCreditHistory(String user) async {
    final http.Response response = await http.get(
        Uri.parse('$_baseUrl/get-credit-transactions'),
        headers: await RequestHeader().authorisedHeader());

    if (response.statusCode != 200) {
      List<Trip> trips = [];
      Session().logSession("trans", response.body);
      return "Unable to update history";
      //return CreditStore.fromJson(jsonDecode(response.body));
    } else {
      Trip trip;
      List<Trip> trips = [];
      int i = 0;
      while (i < 1) {
        LatLng origin = LatLng(double.parse("8.98" + getRandNum()),
            double.parse("38.75"+getRandNum()));
        LatLng destination = LatLng(double.parse("8.98" + getRandNum()),
            double.parse("38.75" + getRandNum()));

        var rng = Random();
        int money = rng.nextInt(100) * i + 237;
        var type = i % 2 == 0 ? 'Gift' : 'Message';
        if (i == 4 || i == 8) {
          type = "Message";
        }
        trip = Trip(
            id: i ,
            date: "Money Received $i",
            from: "Hello you received nothing Thanks",
            time: "soon",
            price: "$money.ETB",
            to: "Today",
            origin: origin,
            destination: destination,
        picture: null);
        trips.add(trip);
        i++;
      }
      //return "Skiped";
      return HistoryDB().insertTrips(trips).then((value) => "updated: $value Items");
      //return trips;
    }
  }
  Future<List<Trip>> loadCreditHistoryDB(String user) async {
      return HistoryDB().trips();
    }


  String getRandNum() {
    var rng = Random();
    print(rng.nextInt(99));
    return rng.nextInt(9999).toString();
  }
}
